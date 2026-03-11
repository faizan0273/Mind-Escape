/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    HintSystem widget displays the hint panel during gameplay.
                Shows available hints as numbered buttons and reveals
                hint text when purchased/unlocked.

---------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cipher_escape/core/constants/colors.dart';
import 'package:cipher_escape/core/constants/dimensions.dart';
import 'package:cipher_escape/core/theme/text_styles.dart';
import 'package:cipher_escape/features/hints/hint_controller.dart';

class HintSystem extends StatelessWidget {
  final HintController ctrl;

  const HintSystem({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient(AppColors.accentGold),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentGold.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: AppColors.accentGold, size: 18),
                const SizedBox(width: AppDimensions.paddingS),
                Text(
                  'HINTS',
                  style: TextStyle(
                    color: AppColors.accentGold,
                    fontSize: AppDimensions.fontS,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),

            // Revealed hints
            if (ctrl.revealedHints.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.paddingS),
              ...ctrl.revealedHints.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.paddingS),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${e.key + 1}. ',
                          style: AppTextStyles.hintText.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            e.value,
                            style: AppTextStyles.hintText,
                            maxLines: 5,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],

            const SizedBox(height: AppDimensions.paddingS),

            // Hint unlock buttons — scrollable horizontally on narrow screens
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (ctrl.hintsUsed.value < 1)
                    _HintButton(
                      number: 1,
                      label: ctrl.hintCostLabel(1),
                      onTap: () => ctrl.useHint(1),
                    ),
                  if (ctrl.hintsUsed.value < 2) ...[
                    const SizedBox(width: AppDimensions.paddingS),
                    _HintButton(
                      number: 2,
                      label: ctrl.hintCostLabel(2),
                      onTap: () => ctrl.useHint(2),
                    ),
                  ],
                  if (ctrl.hintsUsed.value < 3) ...[
                    const SizedBox(width: AppDimensions.paddingS),
                    _HintButton(
                      number: 3,
                      label: ctrl.hintCostLabel(3),
                      onTap: ctrl.isLoadingAd.value ? null : () => ctrl.useHint(3),
                      isLoading: ctrl.isLoadingAd.value,
                    ),
                  ],
                  if (ctrl.hintsUsed.value >= 3)
                    Text(
                      'All hints used',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: AppDimensions.fontS,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _HintButton extends StatelessWidget {
  final int number;
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

  const _HintButton({
    required this.number,
    required this.label,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
        decoration: BoxDecoration(
          color: AppColors.accentGold.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.4)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accentGold),
              )
            : Text(
                'Hint $number  •  $label',
                style: const TextStyle(
                  color: AppColors.accentGold,
                  fontSize: AppDimensions.fontS,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
