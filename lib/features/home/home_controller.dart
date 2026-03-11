/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    HomeController manages the home screen state including
                player data display, level selection, and navigation
                to gameplay, store, and settings.

---------------------------------------------------
*/

import 'package:get/get.dart';
import 'package:cipher_escape/core/constants/game_constants.dart';
import 'package:cipher_escape/engine/game_state_manager.dart';
import 'package:cipher_escape/models/level_model.dart';
import 'package:cipher_escape/models/player_model.dart';
import 'package:cipher_escape/repositories/level_repository.dart';

class HomeController extends GetxController {
  final _state = Get.find<GameStateManager>();
  final _levelRepo = LevelRepository();

  final RxBool showLevelSelect = false.obs;
  final RxString selectedDifficulty = GameConstants.difficultyEasy.obs;

  PlayerModel get player => _state.player.value;
  int get coins => player.coins;
  int get xp => player.xp;
  int get lives => player.lives;
  int get currentLevelId => player.currentLevel;

  List<LevelModel> get allLevels => _levelRepo.allLevels;

  List<LevelModel> get displayedLevels {
    switch (selectedDifficulty.value) {
      case GameConstants.difficultyMedium:
        return _levelRepo.mediumLevels;
      case GameConstants.difficultyHard:
        return _levelRepo.hardLevels;
      default:
        return _levelRepo.easyLevels;
    }
  }

  bool isLevelUnlocked(int levelId) => _levelRepo.isUnlocked(levelId);
  bool isLevelCompleted(int levelId) => _levelRepo.isCompleted(levelId);

  void selectDifficulty(String difficulty) {
    selectedDifficulty.value = difficulty;
  }

  void toggleLevelSelect() {
    showLevelSelect.toggle();
  }

  void startLevel(int levelId) {
    if (!isLevelUnlocked(levelId)) return;
    Get.toNamed(GameConstants.routeGame, arguments: {'levelId': levelId});
  }

  void continueGame() {
    final level = _levelRepo.currentLevel;
    if (level != null) {
      startLevel(level.id);
    }
  }

  void goToStore() {
    Get.toNamed(GameConstants.routeStore);
  }

  void goToAchievements() {
    Get.toNamed(GameConstants.routeAchievements);
  }

  bool get isArchiveUnlocked => _state.isArchiveUnlocked;

  void goToArchive() {
    Get.toNamed(GameConstants.routeArchive);
  }

  bool get hasCompletedAllLevels => _state.hasCompletedAllLevels;

  Future<void> resetLevelProgress() async {
    await _state.resetLevelProgress();
  }

  int get walletBalanceCents => _state.walletBalanceCents.value;
  bool get canWithdraw => _state.canWithdraw;

  void withdraw() {
    if (!canWithdraw) return;
    Get.snackbar(
      'Withdraw',
      'Reached \$50! In a full app you would link a payment method here to withdraw.',
      duration: const Duration(seconds: 4),
    );
  }

  void goToWallet() {
    Get.toNamed(GameConstants.routeWallet);
  }
}
