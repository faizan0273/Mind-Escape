/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Hidden Archive unlocked after the Level 3 mystery hook.
                Shows locked and unlocked story files (endings). Tracks X/7 endings discovered.
---------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cipher_escape/core/constants/colors.dart';
import 'package:cipher_escape/core/constants/dimensions.dart';
import 'package:cipher_escape/core/constants/game_constants.dart';
import 'package:cipher_escape/engine/game_state_manager.dart';
import 'package:cipher_escape/widgets/gaming_background.dart';

class _StoryFile {
  final String id;
  final String title;
  final int unlockAtLevel;
  final String fragment;
  const _StoryFile({required this.id, required this.title, required this.unlockAtLevel, required this.fragment});
}

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  static const List<_StoryFile> storyFiles = [
    _StoryFile(id: 'ending_1', title: 'Fragment 01 — The Back Door', unlockAtLevel: 3, fragment: 'You found the back door. The system was never secure. Someone left this here for you.'),
    _StoryFile(id: 'ending_2', title: 'Fragment 02 — The First Signal', unlockAtLevel: 6, fragment: 'The first message you decoded was a test. They were watching. Now you\'re in.'),
    _StoryFile(id: 'ending_3', title: 'Fragment 03 — Double Cross', unlockAtLevel: 9, fragment: 'Not every sender is who they claim. One of them is lying. One of them is you.'),
    _StoryFile(id: 'ending_4', title: 'Fragment 04 — The Archive', unlockAtLevel: 12, fragment: 'This place is just a mirror. The real archive is inside the facility. Keep going.'),
    _StoryFile(id: 'ending_5', title: 'Fragment 05 — Seven Paths', unlockAtLevel: 15, fragment: 'Seven possible endings. Your choices determine which one you reach. No going back.'),
    _StoryFile(id: 'ending_6', title: 'Fragment 06 — The Overseer', unlockAtLevel: 18, fragment: 'The Overseer is not a single entity. It\'s a pattern. You\'ve been feeding it.'),
    _StoryFile(id: 'ending_7', title: 'Fragment 07 — ???', unlockAtLevel: 21, fragment: 'The last fragment is still encrypted. Complete the path to reveal the final ending.'),
  ];

  @override
  Widget build(BuildContext context) {
    final state = Get.find<GameStateManager>();
    final completed = state.player.value.completedLevels;

    return Scaffold(
      body: SafeArea(
        child: GamingBackground(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                      'ARCHIVE',
                      style: TextStyle(
                        color: AppColors.senderUnknown,
                        fontSize: AppDimensions.fontXL,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                final count = state.storyFilesUnlocked.length;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
                  child: Text(
                    '$count/${GameConstants.totalEndings} endings discovered',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: AppDimensions.fontS,
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppDimensions.paddingM),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
                  itemCount: storyFiles.length,
                  itemBuilder: (context, i) {
                    final file = storyFiles[i];
                    final unlocked = completed.contains(file.unlockAtLevel) ||
                        state.storyFilesUnlocked.contains(file.id);
                    return _StoryFileTile(
                      title: file.title,
                      unlocked: unlocked,
                      fragment: file.fragment,
                      onTap: unlocked
                          ? () => _viewFragment(context, state, file)
                          : () => _showLocked(context, file),
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

  void _viewFragment(BuildContext context, GameStateManager state, _StoryFile file) async {
    if (!state.storyFilesUnlocked.contains(file.id)) {
      await state.unlockStoryFile(file.id);
    }
    if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusL)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              file.title,
              style: const TextStyle(
                color: AppColors.senderUnknown,
                fontSize: AppDimensions.fontL,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingM),
            Text(
              file.fragment,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: AppDimensions.fontM,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLocked(BuildContext context, _StoryFile file) {
    Get.snackbar(
      'Locked',
      'Complete Level ${file.unlockAtLevel} to unlock this fragment.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class _StoryFileTile extends StatelessWidget {
  final String title;
  final bool unlocked;
  final String fragment;
  final VoidCallback onTap;

  const _StoryFileTile({
    required this.title,
    required this.unlocked,
    required this.fragment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      child: Material(
        color: unlocked
            ? AppColors.senderUnknown.withValues(alpha: 0.08)
            : AppColors.backgroundCard.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: unlocked
                    ? AppColors.senderUnknown.withValues(alpha: 0.4)
                    : AppColors.borderColor,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  unlocked ? Icons.folder_open_rounded : Icons.lock_rounded,
                  color: unlocked ? AppColors.senderUnknown : AppColors.textMuted,
                  size: 28,
                ),
                const SizedBox(width: AppDimensions.paddingM),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: unlocked ? AppColors.textPrimary : AppColors.textMuted,
                      fontSize: AppDimensions.fontM,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (unlocked)
                  Icon(Icons.chevron_right_rounded, color: AppColors.senderUnknown),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
