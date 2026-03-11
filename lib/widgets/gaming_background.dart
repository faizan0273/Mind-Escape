/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Full-screen gaming-style gradient background with
                optional subtle vignette for immersion.

---------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:cipher_escape/core/constants/colors.dart';

class GamingBackground extends StatelessWidget {
  final Widget child;
  final Color? overlayColor;

  const GamingBackground({super.key, required this.child, this.overlayColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          // Subtle vignette overlay for depth
          if (overlayColor != null)
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2,
                    colors: [
                      Colors.transparent,
                      overlayColor!.withValues(alpha: 0.15),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
