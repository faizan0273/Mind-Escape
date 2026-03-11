/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Ad service stub for Cipher Escape. Manages rewarded ads
                used to earn hints or extra lives. Wire to google_mobile_ads
                when ready to integrate real ads.

---------------------------------------------------
*/

import 'package:get/get.dart';
import 'package:cipher_escape/core/utils/logger.dart';

class AdService extends GetxService {
  static const _tag = 'AdService';

  final RxBool isAdLoaded = false.obs;
  final RxBool isAdShowing = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadRewardedAd();
    AppLogger.info(_tag, 'AdService initialized');
  }

  void _loadRewardedAd() {
    AppLogger.debug(_tag, 'Loading rewarded ad (stub)');
    Future.delayed(const Duration(seconds: 2), () {
      isAdLoaded.value = true;
    });
  }

  /// Shows a rewarded ad. Returns true if reward was granted.
  Future<bool> showRewardedAd() async {
    if (!isAdLoaded.value) {
      AppLogger.warning(_tag, 'Rewarded ad not ready');
      return false;
    }
    isAdShowing.value = true;
    AppLogger.info(_tag, 'Showing rewarded ad (stub)');
    await Future.delayed(const Duration(seconds: 1));
    isAdShowing.value = false;
    isAdLoaded.value = false;
    _loadRewardedAd();
    return true;
  }
}
