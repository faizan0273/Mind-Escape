/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    StoreScreen displays all purchasable items (hint packs,
                extra lives, coin packs) and handles buy interactions
                via the PurchaseController.

---------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cipher_escape/core/constants/colors.dart';
import 'package:cipher_escape/core/constants/dimensions.dart';
import 'package:cipher_escape/core/theme/text_styles.dart';
import 'package:cipher_escape/engine/game_state_manager.dart';
import 'package:cipher_escape/features/store/purchase_controller.dart';
import 'package:cipher_escape/widgets/gaming_background.dart';
import 'package:cipher_escape/widgets/primary_button.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(PurchaseController());
    final state = Get.find<GameStateManager>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('STORE'),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: AppColors.accentCyan),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppDimensions.paddingM),
            child: Obx(() => Row(
                  children: [
                    const Text('🪙', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Text(
                      '${state.player.value.coins}',
                      style: const TextStyle(
                        color: AppColors.accentGold,
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimensions.fontL,
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GamingBackground(
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + kToolbarHeight,
            left: AppDimensions.paddingM,
            right: AppDimensions.paddingM,
            bottom: AppDimensions.paddingM,
          ),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                'Lives are only restored by watching an ad—not with coins. Use coins for hint passes, or watch ads for coins.',
                style: AppTextStyles.storyText,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingL),
            Expanded(
              child: ListView.separated(
                itemCount: PurchaseController.storeItems.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppDimensions.paddingM),
                itemBuilder: (_, i) {
                  final item = PurchaseController.storeItems[i];
                  return _StoreItemCard(item: item, ctrl: ctrl);
                },
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}

class _StoreItemCard extends StatelessWidget {
  final StoreItem item;
  final PurchaseController ctrl;

  const _StoreItemCard({required this.item, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(item.icon, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppDimensions.fontL,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingS),
          Text(
            item.description,
            style: AppTextStyles.storyText,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Obx(() => SizedBox(
                width: double.infinity,
                height: 42,
                child: PrimaryButton(
                  label: item.cost == 0
                      ? 'Watch Ad'
                      : '${item.cost} 🪙',
                  width: double.infinity,
                  height: 42,
                  isLoading: ctrl.purchasing.value,
                  onTap: ctrl.canAfford(item) ? () => ctrl.purchase(item) : null,
                  color: item.cost == 0
                      ? AppColors.accentCyan
                      : ctrl.canAfford(item)
                          ? AppColors.accentPurple
                          : AppColors.backgroundCard,
                  borderColor: ctrl.canAfford(item) || item.cost == 0
                      ? null
                      : AppColors.borderColor,
                  textColor: ctrl.canAfford(item) || item.cost == 0
                      ? AppColors.textPrimary
                      : AppColors.textMuted,
                ),
              )),
        ],
      ),
    );
  }
}
