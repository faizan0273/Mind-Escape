/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    A reusable dark card container widget with optional
                glowing border accent, used for level cards, stat boxes,
                and content panels throughout the game.

---------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:cipher_escape/core/constants/colors.dart';
import 'package:cipher_escape/core/constants/dimensions.dart';

class GameCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final Color? backgroundColor;
  final double? borderRadius;
  final VoidCallback? onTap;
  final bool glowing;

  const GameCard({
    super.key,
    required this.child,
    this.padding,
    this.borderColor,
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
    this.glowing = false,
  });

  @override
  Widget build(BuildContext context) {
    final border = borderColor ?? AppColors.borderColor;
    final bg = backgroundColor ?? AppColors.backgroundCard;
    final radius = borderRadius ?? AppDimensions.radiusM;

    final decoration = BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: border, width: AppDimensions.cardBorderWidth),
      boxShadow: glowing
          ? [BoxShadow(color: border.withValues(alpha: 0.35), blurRadius: 16, spreadRadius: 2)]
          : null,
    );

    final content = Container(
      padding: padding ?? const EdgeInsets.all(AppDimensions.paddingM),
      decoration: decoration,
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }
    return content;
  }
}
