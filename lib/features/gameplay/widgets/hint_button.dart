/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    HintButton widget — a compact toggle button that opens
                or closes the HintSystem panel during gameplay.

---------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:cipher_escape/core/constants/colors.dart';
import 'package:cipher_escape/core/constants/dimensions.dart';

class HintButton extends StatelessWidget {
  final bool isOpen;
  final int hintsUsed;
  final VoidCallback onTap;

  const HintButton({
    super.key,
    required this.isOpen,
    required this.hintsUsed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: AppDimensions.animFast),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
        decoration: BoxDecoration(
          color: isOpen
              ? AppColors.accentGold.withValues(alpha: 0.15)
              : AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: isOpen
                ? AppColors.accentGold
                : AppColors.accentGold.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: isOpen
              ? [BoxShadow(color: AppColors.accentGold.withValues(alpha: 0.2), blurRadius: 10)]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: AppColors.accentGold,
              size: AppDimensions.iconS,
            ),
            const SizedBox(width: AppDimensions.paddingXS),
            Text(
              'HINT${hintsUsed > 0 ? ' ($hintsUsed/3)' : ''}',
              style: const TextStyle(
                color: AppColors.accentGold,
                fontSize: AppDimensions.fontS,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
