/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    GameEngine coordinates level loading, achievement checks,
                and reward distribution after level completion or failure.

---------------------------------------------------
*/

import 'package:get/get.dart';
import 'package:cipher_escape/core/constants/game_constants.dart';
import 'package:cipher_escape/core/utils/logger.dart';
import 'package:cipher_escape/engine/game_state_manager.dart';
import 'package:cipher_escape/engine/level_loader.dart';
import 'package:cipher_escape/models/level_model.dart';
import 'package:cipher_escape/models/reward_model.dart';

class GameEngine extends GetxService {
  static const _tag = 'GameEngine';

  late final GameStateManager _state;
  late final LevelLoader _loader;

  // Per-session tracking for no-hints streak only (cipher counts are derived from completed levels)
  int _noHintsStreak = 0;

  @override
  void onInit() {
    super.onInit();
    _state = Get.find<GameStateManager>();
    _loader = Get.find<LevelLoader>();
    AppLogger.info(_tag, 'GameEngine initialized');
  }

  /// Processes a successful level completion and grants rewards.
  Future<RewardModel> processLevelSuccess({
    required LevelModel level,
    required int hintsUsed,
    required int? remainingTime,
  }) async {
    final timedBonus = level.isTimed && (remainingTime ?? 0) >= 10;
    final reward = RewardModel.forLevel(
      baseCoins: level.rewardCoins,
      baseXp: level.rewardXp,
      hintsUsed: hintsUsed,
      timedSuccess: timedBonus,
    );

    await _state.addCoins(reward.totalCoins);
    await _state.addXp(reward.xp);
    await _state.completeLevel(level.id);
    await _state.updateStreakAfterSuccess(level.id);

    // Completing all levels earns $5 in the wallet (can withdraw at $50).
    if (level.id == GameConstants.totalLevels) {
      await _state.addToWallet(GameConstants.walletEarnPerCompletionCents);
    }

    if (hintsUsed == 0) {
      _noHintsStreak++;
    } else {
      _noHintsStreak = 0;
    }

    await _checkAchievements(level, hintsUsed, timedBonus);
    AppLogger.info(_tag, 'Level ${level.id} success — +${reward.totalCoins} coins, +${reward.xp} XP');
    return reward;
  }

  /// Counts how many completed levels used each cipher type (from persisted progress).
  Map<String, int> _getCipherCompletionCounts() {
    final completed = _state.player.value.completedLevels;
    final counts = <String, int>{};
    for (final levelId in completed) {
      final lvl = _loader.getLevelById(levelId);
      if (lvl != null) {
        counts[lvl.cipherType] = (counts[lvl.cipherType] ?? 0) + 1;
      }
    }
    return counts;
  }

  /// Processes a failed level attempt (wrong answer).
  Future<void> processLevelFailure(LevelModel level) async {
    await _state.loseLife();
    await _state.resetStreak();
    AppLogger.info(_tag, 'Level ${level.id} failed — lives left: ${_state.player.value.lives}');
  }

  Future<void> _checkAchievements(
    LevelModel level,
    int hintsUsed,
    bool timedBonus,
  ) async {
    final completed = _state.player.value.completedLevels;
    final cipherCounts = _getCipherCompletionCounts();

    if (completed.length == 1) {
      await _state.unlockAchievement(GameConstants.achievementFirstEscape);
    }
    if ((cipherCounts[GameConstants.cipherBinary] ?? 0) >= 3) {
      await _state.unlockAchievement(GameConstants.achievementBinaryExpert);
    }
    if ((cipherCounts[GameConstants.cipherMorse] ?? 0) >= 1) {
      await _state.unlockAchievement(GameConstants.achievementMorseMaster);
    }
    if (timedBonus) {
      await _state.unlockAchievement(GameConstants.achievementSpeedRunner);
    }
    if (_noHintsStreak >= 5) {
      await _state.unlockAchievement(GameConstants.achievementNoHints);
    }
    if (level.id == 10) {
      await _state.unlockAchievement(GameConstants.achievementPhase1);
    }
    if (level.id == 20) {
      await _state.unlockAchievement(GameConstants.achievementPhase2);
    }
    if (level.id == 30) {
      await _state.unlockAchievement(GameConstants.achievementPhase3);
      await _state.unlockAchievement(GameConstants.achievementMasterDecoder);
    }
  }

  LevelModel? get nextLevel =>
      _loader.getNextLevel(_state.player.value.currentLevel - 1);
}
