/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Analytics service stub for Cipher Escape. Tracks game
                events like level completions, hints used, and cipher types
                decoded. Wire to Firebase Analytics when ready.

---------------------------------------------------
*/

import 'package:get/get.dart';
import 'package:cipher_escape/core/utils/logger.dart';

class AnalyticsService extends GetxService {
  static const _tag = 'AnalyticsService';

  @override
  void onInit() {
    super.onInit();
    AppLogger.info(_tag, 'AnalyticsService initialized');
  }

  void logLevelStart(int levelId, String difficulty) {
    AppLogger.debug(_tag, 'Event: level_start | id=$levelId, diff=$difficulty');
  }

  void logLevelComplete(int levelId, int hintsUsed, bool timed) {
    AppLogger.debug(
        _tag, 'Event: level_complete | id=$levelId, hints=$hintsUsed, timed=$timed');
  }

  void logLevelFailed(int levelId, String cipherType) {
    AppLogger.debug(
        _tag, 'Event: level_failed | id=$levelId, cipher=$cipherType');
  }

  void logHintUsed(int levelId, int hintNumber) {
    AppLogger.debug(
        _tag, 'Event: hint_used | level=$levelId, hint=$hintNumber');
  }

  void logAchievementUnlocked(String achievementId) {
    AppLogger.debug(
        _tag, 'Event: achievement_unlocked | id=$achievementId');
  }

  void logStorePurchase(String itemId, int cost) {
    AppLogger.debug(_tag, 'Event: store_purchase | item=$itemId, cost=$cost');
  }
}
