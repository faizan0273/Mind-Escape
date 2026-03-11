/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Gaming-focused color palette: deep darks, neon accents,
                gradients and glow colors for an immersive puzzle game UI.

---------------------------------------------------
*/

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background — deeper, more atmospheric
  static const Color backgroundDark = Color(0xFF050810);
  static const Color backgroundCard = Color(0xFF0F1420);
  static const Color backgroundCardElevated = Color(0xFF151C2C);
  static const Color backgroundOverlay = Color(0xFF0A0E18);
  static const Color backgroundInput = Color(0xFF080C14);

  // Neon accents — brighter for gaming punch
  static const Color accentCyan = Color(0xFF00FFE5);
  static const Color accentPurple = Color(0xFFA855F7);
  static const Color accentGold = Color(0xFFFFC107);
  static const Color accentOrange = Color(0xFFFF6B35);

  // Status — high contrast
  static const Color success = Color(0xFF00E676);
  static const Color danger = Color(0xFFFF1744);
  static const Color warning = Color(0xFFFFAB00);
  static const Color info = Color(0xFF00B8D4);

  // Text
  static const Color textPrimary = Color(0xFFF0F0F8);
  static const Color textSecondary = Color(0xFFB0B4C0);
  static const Color textMuted = Color(0xFF5A5E70);
  static const Color textCipher = Color(0xFF00FFE5);

  // Sender colors
  static const Color senderHelper = Color(0xFF00E676);
  static const Color senderEnemy = Color(0xFFFF1744);
  static const Color senderFuture = Color(0xFFA855F7);
  static const Color senderUnknown = Color(0xFFFFAB00);
  static const Color senderGhost = Color(0xFF9A9EB5);

  // Button
  static const Color buttonPrimary = Color(0xFFA855F7);
  static const Color buttonSecondary = Color(0xFF151C2C);

  // Border / glow — stronger for gaming feel
  static const Color borderColor = Color(0xFF1E2433);
  static const Color glowCyan = Color(0x5500FFE5);
  static const Color glowPurple = Color(0x55A855F7);
  static const Color glowRed = Color(0x55FF1744);
  static const Color glowGreen = Color(0x5500E676);
  static const Color glowGold = Color(0x55FFC107);

  // Difficulty
  static const Color difficultyEasy = Color(0xFF00E676);
  static const Color difficultyMedium = Color(0xFFFFAB00);
  static const Color difficultyHard = Color(0xFFFF1744);

  // Gradient definitions for gaming panels and buttons
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0A0E1E),
      Color(0xFF050810),
      Color(0xFF030508),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static LinearGradient cardGradient(Color accent) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          accent.withValues(alpha: 0.08),
          backgroundCard,
          backgroundCard,
        ],
        stops: const [0.0, 0.4, 1.0],
      );

  static LinearGradient buttonGradient(Color accent) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          accent.withValues(alpha: 0.35),
          accent.withValues(alpha: 0.15),
        ],
      );

  static List<BoxShadow> glowShadow(Color color, {double blur = 20, double spread = 0}) => [
        BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: blur, spreadRadius: spread),
        BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: blur * 2, spreadRadius: spread),
      ];

  static List<BoxShadow> softInnerShadow() => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
}
