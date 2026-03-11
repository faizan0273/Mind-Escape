/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Achievements screen showing all unlockable achievements
                and which ones the player has earned (progression system).
---------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cipher_escape/core/constants/colors.dart';
import 'package:cipher_escape/core/constants/dimensions.dart';
import 'package:cipher_escape/engine/game_state_manager.dart';
import 'package:cipher_escape/models/reward_model.dart';
import 'package:cipher_escape/widgets/gaming_background.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Get.find<GameStateManager>();

    return Scaffold(
      body: SafeArea(
        child: GamingBackground(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textMuted, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'ACHIEVEMENTS',
                      style: TextStyle(
                        color: AppColors.accentGold,
                        fontSize: AppDimensions.fontXL,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Obx(() {
                final unlocked = state.player.value.achievements.length;
                final total = AchievementModel.all.length;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
                  child: Text(
                    '$unlocked / $total unlocked',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: AppDimensions.fontS,
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppDimensions.paddingL),

              // List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
                  itemCount: AchievementModel.all.length,
                  itemBuilder: (context, index) {
                    final a = AchievementModel.all[index];
                    final isUnlocked = state.player.value.hasAchievement(a.id);
                    return _AchievementTile(
                      title: a.title,
                      description: a.description,
                      icon: a.icon,
                      unlocked: isUnlocked,
                    );
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

class _AchievementTile extends StatelessWidget {
  final String title;
  final String description;
  final String icon;
  final bool unlocked;

  const _AchievementTile({
    required this.title,
    required this.description,
    required this.icon,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: unlocked
              ? AppColors.accentGold.withValues(alpha: 0.08)
              : AppColors.backgroundCard.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: unlocked
                ? AppColors.accentGold.withValues(alpha: 0.4)
                : AppColors.borderColor,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: unlocked
                    ? AppColors.accentGold.withValues(alpha: 0.2)
                    : AppColors.backgroundInput,
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Text(
                icon,
                style: TextStyle(
                  fontSize: 24,
                  color: unlocked ? null : AppColors.textMuted,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: unlocked ? AppColors.textPrimary : AppColors.textMuted,
                      fontSize: AppDimensions.fontL,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: AppDimensions.fontS,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (unlocked)
              const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 28)
            else
              Icon(Icons.lock_outline_rounded, color: AppColors.textMuted, size: 22),
          ],
        ),
      ),
    );
  }
}
