/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Story-driven scene intro shown at the start of each level.
                Displays narrative text and a "Receive message" / "Continue" action.
---------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:cipher_escape/core/constants/colors.dart';
import 'package:cipher_escape/core/constants/dimensions.dart';

class SceneIntro extends StatelessWidget {
  final String story;
  final int chapterNumber;
  final String chapterTitle;
  final String levelTitle;
  final VoidCallback onContinue;

  const SceneIntro({
    super.key,
    required this.story,
    required this.chapterNumber,
    required this.chapterTitle,
    required this.levelTitle,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingL,
            vertical: AppDimensions.paddingM,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: AppDimensions.paddingL),

                // Chapter & level
                Text(
                  'CHAPTER $chapterNumber',
                  style: TextStyle(
                    color: AppColors.accentCyan.withValues(alpha: 0.9),
                    fontSize: AppDimensions.fontS,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  chapterTitle.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.accentCyan,
                    fontSize: AppDimensions.fontXL,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.0,
                    shadows: [
                      Shadow(color: AppColors.glowCyan, blurRadius: 16),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  levelTitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppDimensions.fontM,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimensions.paddingXL),
                // Scene narrative
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundCard.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                    border: Border.all(color: AppColors.borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                  story,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppDimensions.fontL,
                    height: 1.75,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 15,
                  overflow: TextOverflow.fade,
                ),
                ),
                const SizedBox(height: AppDimensions.paddingXL),
                Text(
                  'Your device vibrates. An encrypted message is incoming.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: AppDimensions.fontS,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingM),
                GestureDetector(
                onTap: onContinue,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingM,
                    horizontal: AppDimensions.paddingL,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accentCyan.withValues(alpha: 0.3),
                        AppColors.accentCyan.withValues(alpha: 0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    border: Border.all(color: AppColors.accentCyan, width: 2),
                    boxShadow: [
                      ...AppColors.glowShadow(AppColors.accentCyan, blur: 16),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.notifications_active, color: AppColors.accentCyan, size: 22),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          'RECEIVE MESSAGE',
                          style: TextStyle(
                            color: AppColors.accentCyan,
                            fontSize: AppDimensions.fontL,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                ),
                const SizedBox(height: AppDimensions.paddingXL),
              ],
            ),
          ),
        );
      },
    );
  }
}
