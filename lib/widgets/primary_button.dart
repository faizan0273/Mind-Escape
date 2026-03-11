/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Reusable neon-styled primary button widget used throughout
                the Cipher Escape UI. Supports loading and disabled states.

---------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:cipher_escape/core/constants/colors.dart';
import 'package:cipher_escape/core/constants/dimensions.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.color,
    this.textColor,
    this.borderColor,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = AppDimensions.actionButtonHeight,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.accentPurple;
    final fg = textColor ?? AppColors.textPrimary;
    final border = borderColor ?? bg;
    final enabled = onTap != null && !isLoading;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: AppDimensions.animFast),
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          gradient: enabled ? AppColors.buttonGradient(bg) : null,
          color: enabled ? null : AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: enabled ? border : AppColors.borderColor,
            width: 2,
          ),
          boxShadow: enabled ? AppColors.glowShadow(bg, blur: 14, spread: 0) : null,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(fg),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: fg, size: AppDimensions.iconM),
                      const SizedBox(width: AppDimensions.paddingS),
                    ],
                    Flexible(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: fg,
                          fontSize: AppDimensions.fontL,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          shadows: enabled
                              ? [Shadow(color: bg.withValues(alpha: 0.5), blurRadius: 8)]
                              : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
