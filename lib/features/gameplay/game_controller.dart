/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    GameController drives the core gameplay loop for a single
                level: timer, choice evaluation, hint integration, and
                navigation to the result screen.

---------------------------------------------------
*/

import 'dart:async';
import 'package:get/get.dart';
import 'package:cipher_escape/core/constants/game_constants.dart';
import 'package:cipher_escape/core/services/analytics_service.dart';
import 'package:cipher_escape/core/services/sound_service.dart';
import 'package:cipher_escape/core/utils/logger.dart';
import 'package:cipher_escape/engine/game_engine.dart';
import 'package:cipher_escape/engine/game_state_manager.dart';
import 'package:cipher_escape/features/gameplay/puzzle_handler.dart';
import 'package:cipher_escape/features/hints/hint_controller.dart';
import 'package:cipher_escape/models/level_model.dart';
import 'package:cipher_escape/models/puzzle_model.dart';
import 'package:cipher_escape/models/reward_model.dart';
import 'package:cipher_escape/repositories/level_repository.dart';
import 'package:cipher_escape/repositories/puzzle_repository.dart';

class GameController extends GetxController {
  static const _tag = 'GameController';

  final _engine = Get.find<GameEngine>();
  final _sound = Get.find<SoundService>();
  final _analytics = Get.find<AnalyticsService>();
  final _levelRepo = LevelRepository();
  final _puzzleRepo = PuzzleRepository();
  final _handler = PuzzleHandler();
  late final HintController hintCtrl;

  // ── Reactive state ────────────────────────────────────────────────────────

  final Rx<LevelModel?> level = Rx(null);
  final Rx<PuzzleModel?> puzzle = Rx(null);
  final RxInt? selectedChoiceId = RxInt(-1);
  final RxBool isRevealed = false.obs;
  final RxBool isCorrect = false.obs;
  final RxBool showHints = false.obs;
  final RxBool showCipherType = false.obs;
  final RxBool showSceneIntro = true.obs;
  final RxInt timerSeconds = 0.obs;
  final RxBool timerRunning = false.obs;
  final RxBool isProcessing = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    hintCtrl = Get.put(HintController());
    final args = Get.arguments as Map<String, dynamic>?;
    final levelId = args?['levelId'] as int? ?? 1;
    _loadLevel(levelId);
  }

  /// Call when navigating to GameScreen (e.g. from Result "Next Level" or "Try Again").
  /// Reuses the same controller: load new level or reset state for retry.
  void loadLevelIfNeeded(int levelId) {
    final currentLevel = level.value;
    if (currentLevel?.id == levelId) {
      // Retry same level: reset options, hints, and timer so the level is fresh
      _resetLevelState();
      hintCtrl.initForLevel(currentLevel!);
      puzzle.value = _puzzleRepo.createFromLevel(currentLevel);
      timerSeconds.value = currentLevel.timeLimit ?? GameConstants.defaultLevelTimeLimit;
      // Timer starts when player taps to start puzzle (startPuzzle), not here
      AppLogger.info(_tag, 'Level ${currentLevel.id} retry — state reset');
      return;
    }
    _resetLevelState();
    _loadLevel(levelId);
  }

  void _resetLevelState() {
    selectedChoiceId?.value = -1;
    isRevealed.value = false;
    isCorrect.value = false;
    showHints.value = false;
    showSceneIntro.value = true;
    isProcessing.value = false;
    _timer?.cancel();
    timerRunning.value = false;
  }

  /// Called after the player taps "Continue" on the scene intro — reveals the puzzle, plays message sound, and starts the level timer.
  void startPuzzle() {
    showSceneIntro.value = false;
    _sound.playMessageNotification();
    final lvl = level.value;
    if (lvl != null && timerSeconds.value > 0 && !timerRunning.value) {
      _startTimer();
    }
  }

  void _loadLevel(int id) {
    final lvl = _levelRepo.getLevelById(id);
    if (lvl == null) {
      AppLogger.error(_tag, 'Level $id not found');
      Get.back();
      return;
    }
    level.value = lvl;
    puzzle.value = _puzzleRepo.createFromLevel(lvl);
    hintCtrl.initForLevel(lvl);

    // Tutorial levels (1-3) show cipher type automatically
    showCipherType.value = lvl.id <= 3;

    // Every level has a time limit; if crossed, player loses a life. Timer starts when puzzle starts (startPuzzle).
    timerSeconds.value = lvl.timeLimit ?? GameConstants.defaultLevelTimeLimit;

    _analytics.logLevelStart(lvl.id, lvl.difficulty);
    AppLogger.info(_tag, 'Level ${lvl.id} loaded: ${lvl.title}');
  }

  void _startTimer() {
    timerRunning.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (timerSeconds.value <= 0) {
        _timer?.cancel();
        timerRunning.value = false;
        _onTimerExpired();
        return;
      }
      timerSeconds.value--;
    });
  }

  void _onTimerExpired() {
    if (isRevealed.value) return;
    final lvl = level.value;
    if (lvl == null) return;
    AppLogger.info(_tag, 'Timer expired on level ${lvl.id}');
    isRevealed.value = true;
    isCorrect.value = false;
    _sound.playWrong();
    _engine.processLevelFailure(lvl);
    _analytics.logLevelFailed(lvl.id, lvl.cipherType);
    Future.delayed(const Duration(milliseconds: 1200), () {
      _navigateResult(false, wrongChoiceText: 'Time ran out');
    });
  }

  void toggleHints() => showHints.toggle();

  void revealCipherType() => showCipherType.value = true;

  Future<void> submitChoice(ChoiceModel choice) async {
    if (isRevealed.value || isProcessing.value) return;
    _timer?.cancel();
    timerRunning.value = false;
    isProcessing.value = true;

    final puz = puzzle.value!;
    final lvl = level.value!;
    final correct = _handler.evaluateChoice(puz, choice);

    selectedChoiceId?.value = choice.id;
    isRevealed.value = true;
    isCorrect.value = correct;

    if (correct) {
      _sound.playDoorOpen();
      final remaining = (lvl.timeLimit != null || timerSeconds.value > 0) ? timerSeconds.value : null;
      final reward = await _engine.processLevelSuccess(
        level: lvl,
        hintsUsed: hintCtrl.hintsUsed.value,
        remainingTime: remaining,
      );
      _analytics.logLevelComplete(lvl.id, hintCtrl.hintsUsed.value, lvl.isTimed);
      await Future.delayed(const Duration(milliseconds: 1400));
      final state = Get.find<GameStateManager>();
      final shouldShowMysteryHook = lvl.id == GameConstants.mysteryHookLevel &&
          !state.hasSeenMysteryHook;
      if (shouldShowMysteryHook) {
        _navigateMysteryHook(reward: reward);
      } else {
        _navigateResult(true, reward: reward);
      }
    } else {
      _sound.playFailure();
      await _engine.processLevelFailure(lvl);
      _analytics.logLevelFailed(lvl.id, lvl.cipherType);
      await Future.delayed(const Duration(milliseconds: 2200));
      _navigateResult(false, wrongChoiceText: choice.text);
    }

    isProcessing.value = false;
  }

  void _navigateResult(bool success, {RewardModel? reward, String? wrongChoiceText}) {
    Get.toNamed(
      GameConstants.routeResult,
      arguments: {
        'success': success,
        'levelId': level.value!.id,
        'reward': reward,
        'hintsUsed': hintCtrl.hintsUsed.value,
        'wrongChoiceText': wrongChoiceText,
      },
    );
  }

  void _navigateMysteryHook({RewardModel? reward}) {
    Get.offNamed(
      GameConstants.routeMysteryHook,
      arguments: {
        'success': true,
        'levelId': level.value!.id,
        'reward': reward,
        'hintsUsed': hintCtrl.hintsUsed.value,
      },
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
