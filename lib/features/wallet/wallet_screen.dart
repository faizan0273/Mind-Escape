/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Wallet page opened when user taps the wallet chip on home.
                Shows balance, earn/withdraw rules, and withdraw button at $50.

---------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cipher_escape/core/constants/colors.dart';
import 'package:cipher_escape/core/constants/dimensions.dart';
import 'package:cipher_escape/core/constants/game_constants.dart';
import 'package:cipher_escape/engine/game_state_manager.dart';
import 'package:cipher_escape/features/home/home_controller.dart';
import 'package:cipher_escape/widgets/gaming_background.dart';
import 'package:cipher_escape/widgets/primary_button.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Get.find<GameStateManager>();
    final ctrl = Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('WALLET'),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: AppColors.accentGold),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: GamingBackground(
        overlayColor: AppColors.accentGold.withValues(alpha: 0.06),
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + kToolbarHeight,
            left: AppDimensions.paddingL,
            right: AppDimensions.paddingL,
            bottom: AppDimensions.paddingL,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimensions.paddingXL),
                Obx(() {
                  final cents = state.walletBalanceCents.value;
                  final balanceStr = '\$${(cents / 100).toStringAsFixed(2)}';
                  return Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingXL),
                    decoration: BoxDecoration(
                      gradient: AppColors.cardGradient(AppColors.accentGold),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                      border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.5)),
                      boxShadow: AppColors.glowShadow(AppColors.accentGold, blur: 16),
                    ),
                    child: Column(
                      children: [
                        const Text('💰', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: AppDimensions.paddingM),
                        Text(
                          'Balance',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: AppDimensions.fontS,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          balanceStr,
                          style: const TextStyle(
                            color: AppColors.accentGold,
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: AppDimensions.paddingXL),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundCard.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How it works',
                        style: TextStyle(
                          color: AppColors.accentGold,
                          fontSize: AppDimensions.fontL,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingM),
                      Text(
                        'Complete all ${GameConstants.totalLevels} levels to earn \$5. Each time you finish every level, \$5 is added to your wallet.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: AppDimensions.fontM,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingM),
                      Text(
                        'You can withdraw when your balance reaches \$50.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: AppDimensions.fontM,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXL),
                Obx(() {
                  if (!state.canWithdraw) {
                    return Text(
                      'Keep playing to reach \$50 and unlock withdraw.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: AppDimensions.fontS,
                      ),
                    );
                  }
                  return PrimaryButton(
                    label: 'WITHDRAW (\$50+)',
                    onTap: ctrl.withdraw,
                    color: AppColors.accentGold,
                    borderColor: AppColors.accentGold,
                  );
                }),
                const SizedBox(height: AppDimensions.paddingXL),
                Obx(() {
                  if (!ctrl.hasCompletedAllLevels) return const SizedBox.shrink();
                  return PrimaryButton(
                    label: 'RESET & PLAY AGAIN',
                    onTap: () async {
                      await ctrl.resetLevelProgress();
                      if (context.mounted) {
                        Get.back();
                        Get.snackbar('Progress reset', 'Play from level 1 again!');
                      }
                    },
                    color: AppColors.backgroundCard,
                    borderColor: AppColors.borderColor,
                    textColor: AppColors.textSecondary,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
