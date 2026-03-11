/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    ResultController handles post-level navigation logic:
                retry, next level, or return to home, depending on
                whether the player succeeded or failed.

---------------------------------------------------
*/

import 'package:get/get.dart';
import 'package:cipher_escape/core/constants/game_constants.dart';
import 'package:cipher_escape/core/services/ad_service.dart';
import 'package:cipher_escape/engine/game_state_manager.dart';
import 'package:cipher_escape/models/level_model.dart';
import 'package:cipher_escape/models/reward_model.dart';
import 'package:cipher_escape/repositories/level_repository.dart';

class ResultController extends GetxController {
  final _state = Get.find<GameStateManager>();
  final _ads = Get.find<AdService>();
  final _levelRepo = LevelRepository();

  final RxBool isLoadingAd = false.obs;

  late final bool success;
  late final int levelId;
  late final RewardModel? reward;
  late final int hintsUsed;
  late final String? wrongChoiceText;
  late final LevelModel? currentLevel;
  late final LevelModel? nextLevel;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    success = args['success'] as bool? ?? false;
    levelId = args['levelId'] as int? ?? 1;
    reward = args['reward'] as RewardModel?;
    hintsUsed = args['hintsUsed'] as int? ?? 0;
    wrongChoiceText = args['wrongChoiceText'] as String?;
    currentLevel = _levelRepo.getLevelById(levelId);
    nextLevel = _levelRepo.getNextLevel(levelId);
  }

  bool get hasLives => _state.hasLives;
  int get lives => _state.player.value.lives;

  void retryLevel() {
    Get.offNamed(
      GameConstants.routeGame,
      arguments: {'levelId': levelId},
    );
  }

  void goToNextLevel() {
    if (nextLevel != null) {
      Get.offNamed(
        GameConstants.routeGame,
        arguments: {'levelId': nextLevel!.id},
      );
    } else {
      Get.offAllNamed(GameConstants.routeHome);
    }
  }

  void goToHome() {
    Get.offAllNamed(GameConstants.routeHome);
  }

  void goToStore() {
    Get.toNamed(GameConstants.routeStore);
  }

  /// Watch a rewarded ad to get 1 life. Required to continue when out of lives.
  Future<void> watchAdForLife() async {
    if (_state.player.value.lives >= GameConstants.defaultLives) return;
    isLoadingAd.value = true;
    final rewarded = await _ads.showRewardedAd();
    isLoadingAd.value = false;
    if (rewarded) {
      await _state.restoreLives(1);
      Get.snackbar('Life restored!', '❤️ Watch an ad to try again.');
    } else {
      Get.snackbar('Ad not ready', 'Try again in a moment.');
    }
  }
}
