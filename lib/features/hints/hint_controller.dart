/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    HintController manages hint usage during gameplay.
                Tracks which hints have been revealed and handles
                the cost/reward-ad logic for unlocking hints.

---------------------------------------------------
*/

import 'package:get/get.dart';
import 'package:cipher_escape/core/constants/game_constants.dart';
import 'package:cipher_escape/core/services/ad_service.dart';
import 'package:cipher_escape/core/services/analytics_service.dart';
import 'package:cipher_escape/core/services/sound_service.dart';
import 'package:cipher_escape/engine/game_state_manager.dart';
import 'package:cipher_escape/models/level_model.dart';
import 'package:cipher_escape/repositories/puzzle_repository.dart';

class HintController extends GetxController {
  final _state = Get.find<GameStateManager>();
  final _adService = Get.find<AdService>();
  final _analytics = Get.find<AnalyticsService>();
  final _sound = Get.find<SoundService>();
  final _puzzleRepo = PuzzleRepository();

  final RxInt hintsUsed = 0.obs;
  final RxList<String> revealedHints = <String>[].obs;
  final RxBool isLoadingAd = false.obs;

  late LevelModel _level;

  void initForLevel(LevelModel level) {
    _level = level;
    hintsUsed.value = 0;
    revealedHints.clear();
  }

  bool get canUseHint1 => hintsUsed.value < 1;
  bool get canUseHint2 => hintsUsed.value < 2;
  bool get canUseHint3 => hintsUsed.value < 3;

  /// Hint 1 is free. Hint 2 costs coins. Hint 3 requires a rewarded ad.
  Future<bool> useHint(int hintNumber) async {
    if (hintsUsed.value >= hintNumber) return false;

    if (hintNumber == 2) {
      final cost = GameConstants.hint2Cost;
      final success = await _state.spendCoins(cost);
      if (!success) {
        Get.snackbar('Not enough coins', 'You need $cost coins for Hint 2.');
        return false;
      }
    }

    if (hintNumber == 3) {
      isLoadingAd.value = true;
      final rewarded = await _adService.showRewardedAd();
      isLoadingAd.value = false;
      if (!rewarded) {
        Get.snackbar('Ad not available', 'Watch an ad to unlock Hint 3.');
        return false;
      }
    }

    final hintText = _puzzleRepo.getHint(_level, hintNumber);
    revealedHints.add(hintText);
    hintsUsed.value = hintNumber;
    _sound.playHint();
    _analytics.logHintUsed(_level.id, hintNumber);
    return true;
  }

  String hintCostLabel(int hintNumber) {
    switch (hintNumber) {
      case 1:
        return 'FREE';
      case 2:
        return '${GameConstants.hint2Cost} 🪙';
      case 3:
        return 'Watch Ad';
      default:
        return '';
    }
  }
}
