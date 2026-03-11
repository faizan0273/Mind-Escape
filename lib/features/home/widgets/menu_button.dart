/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    MenuButton widget used on the HomeScreen for primary
                navigation actions (Play, Levels, Store, Settings).

---------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:cipher_escape/core/constants/colors.dart';
import 'package:cipher_escape/core/constants/dimensions.dart';

class MenuButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? accentColor;
  final String? subtitle;

  const MenuButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.accentColor,
    this.subtitle,
  });

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppDimensions.animFast),
      lowerBound: 0.95,
      upperBound: 1.0,
    )..value = 1.0;
    _scaleAnim = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _controller.reverse();
  void _onTapUp(_) {
    _controller.forward();
    widget.onTap();
  }

  void _onTapCancel() => _controller.forward();

  @override
  Widget build(BuildContext context) {
    final color = widget.accentColor ?? AppColors.accentCyan;
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          height: AppDimensions.menuButtonHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient(color),
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(color: color.withValues(alpha: 0.6), width: 2),
            boxShadow: [
              ...AppColors.glowShadow(color, blur: 16, spread: 0),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Icon(widget.icon, color: color, size: AppDimensions.iconL),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: AppDimensions.fontXL,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(color: color.withValues(alpha: 0.3), blurRadius: 8),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.subtitle != null)
                      Flexible(
                        child: Text(
                          widget.subtitle!,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: AppDimensions.fontS,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: color.withValues(alpha: 0.8), size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
