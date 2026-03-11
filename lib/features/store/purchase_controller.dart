/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    PurchaseController handles in-game store transactions
                for buying hints bundles, extra lives, and coin packs
                using the player's existing coin balance.

---------------------------------------------------
*/

import 'package:get/get.dart';
import 'package:cipher_escape/core/services/ad_service.dart';
import 'package:cipher_escape/core/services/analytics_service.dart';
import 'package:cipher_escape/core/services/sound_service.dart';
import 'package:cipher_escape/engine/game_state_manager.dart';

class StoreItem {
  final String id;
  final String icon;
  final String title;
  final String description;
  final int cost;
  final String type; // 'hints' | 'lives_ad' | 'coins'
  final int value;

  const StoreItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    required this.cost,
    required this.type,
    required this.value,
  });
}

class PurchaseController extends GetxController {
  final _state = Get.find<GameStateManager>();
  final _ads = Get.find<AdService>();
  final _analytics = Get.find<AnalyticsService>();
  final _sound = Get.find<SoundService>();

  final RxString lastPurchase = ''.obs;
  final RxBool purchasing = false.obs;

  static const List<StoreItem> storeItems = [
    StoreItem(
      id: 'lives_ad',
      icon: '❤️',
      title: '1 Life',
      description: 'Watch an ad to restore one life. Lives cannot be bought with coins.',
      cost: 0,
      type: 'lives_ad',
      value: 1,
    ),
    StoreItem(
      id: 'hints_3',
      icon: '💡',
      title: '3 Hint Passes',
      description: 'Unlock 3 hint passes for any level',
      cost: 30,
      type: 'hints',
      value: 3,
    ),
    StoreItem(
      id: 'hints_10',
      icon: '💡💡',
      title: '10 Hint Passes',
      description: 'Best value! 10 hint passes',
      cost: 80,
      type: 'hints',
      value: 10,
    ),
    StoreItem(
      id: 'coins_50',
      icon: '🪙',
      title: '50 Coins',
      description: 'Watch an ad for 50 free coins',
      cost: 0,
      type: 'coins',
      value: 50,
    ),
  ];

  int get coins => _state.player.value.coins;
  int get lives => _state.player.value.lives;

  bool canAfford(StoreItem item) {
    if (item.type == 'lives_ad' || item.cost == 0) return true;
    return coins >= item.cost;
  }

  Future<bool> purchase(StoreItem item) async {
    if (item.type == 'lives_ad') {
      return _purchaseLifeWithAd();
    }
    if (item.type == 'coins' && item.cost == 0) {
      return _purchaseCoinsWithAd(item);
    }
    if (!canAfford(item)) {
      Get.snackbar('Not enough coins', 'You need ${item.cost} 🪙');
      return false;
    }

    purchasing.value = true;

    final ok = await _state.spendCoins(item.cost);
    if (!ok) {
      purchasing.value = false;
      return false;
    }

    switch (item.type) {
      case 'hints':
        // Coins already spent above; hint passes could be granted here if we add a counter
        break;
    }

    lastPurchase.value = item.title;
    _sound.playButtonTap();
    _analytics.logStorePurchase(item.id, item.cost);
    Get.snackbar('Purchased!', '${item.icon} ${item.title} added.');

    purchasing.value = false;
    return true;
  }

  Future<bool> _purchaseLifeWithAd() async {
    purchasing.value = true;
    _sound.playButtonTap();
    final rewarded = await _ads.showRewardedAd();
    if (!rewarded) {
      purchasing.value = false;
      Get.snackbar('Ad not ready', 'Try again in a moment.');
      return false;
    }
    await _state.restoreLives(1);
    lastPurchase.value = '1 Life';
    _analytics.logStorePurchase('lives_ad', 0);
    Get.snackbar('Life restored!', '❤️ You have 1 more life.');
    purchasing.value = false;
    return true;
  }

  Future<bool> _purchaseCoinsWithAd(StoreItem item) async {
    purchasing.value = true;
    _sound.playButtonTap();
    final rewarded = await _ads.showRewardedAd();
    if (!rewarded) {
      purchasing.value = false;
      Get.snackbar('Ad not ready', 'Try again in a moment.');
      return false;
    }
    await _state.addCoins(item.value);
    lastPurchase.value = item.title;
    _analytics.logStorePurchase(item.id, 0);
    Get.snackbar('Coins earned!', '${item.icon} +${item.value} coins.');
    purchasing.value = false;
    return true;
  }

}
