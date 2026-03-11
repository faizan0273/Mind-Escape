/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Reusable TextStyle constants for Cipher Escape,
                including cipher display fonts and story text styles.

---------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:cipher_escape/core/constants/colors.dart';
import 'package:cipher_escape/core/constants/dimensions.dart';

class AppTextStyles {
  AppTextStyles._();

  // Game title
  static const TextStyle gameTitle = TextStyle(
    color: AppColors.accentCyan,
    fontSize: AppDimensions.fontDisplay,
    fontWeight: FontWeight.bold,
    letterSpacing: 4.0,
    fontFamily: 'monospace',
  );

  // Cipher / encrypted message display
  static const TextStyle cipherDisplay = TextStyle(
    color: AppColors.textCipher,
    fontSize: AppDimensions.fontCipher,
    fontWeight: FontWeight.bold,
    fontFamily: 'monospace',
    letterSpacing: 2.0,
    height: 1.8,
  );

  // Decoded message reveal
  static const TextStyle decodedMessage = TextStyle(
    color: AppColors.success,
    fontSize: AppDimensions.fontXXL,
    fontWeight: FontWeight.bold,
    fontFamily: 'monospace',
    letterSpacing: 3.0,
  );

  // Story / narrative text
  static const TextStyle storyText = TextStyle(
    color: AppColors.textSecondary,
    fontSize: AppDimensions.fontM,
    height: 1.7,
    fontStyle: FontStyle.italic,
  );

  // Sender label
  static const TextStyle senderLabel = TextStyle(
    fontSize: AppDimensions.fontS,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
    fontFamily: 'monospace',
  );

  // Level title
  static const TextStyle levelTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: AppDimensions.fontXL,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );

  // Action button text
  static const TextStyle actionButton = TextStyle(
    color: AppColors.textPrimary,
    fontSize: AppDimensions.fontL,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // Hint text
  static const TextStyle hintText = TextStyle(
    color: AppColors.accentGold,
    fontSize: AppDimensions.fontM,
    fontStyle: FontStyle.italic,
    height: 1.5,
  );

  // Stat label (coins, XP)
  static const TextStyle statLabel = TextStyle(
    color: AppColors.textSecondary,
    fontSize: AppDimensions.fontS,
    letterSpacing: 1.0,
  );

  static const TextStyle statValue = TextStyle(
    color: AppColors.textPrimary,
    fontSize: AppDimensions.fontL,
    fontWeight: FontWeight.bold,
  );

  // Timer text
  static const TextStyle timer = TextStyle(
    fontSize: AppDimensions.fontXXL,
    fontWeight: FontWeight.bold,
    fontFamily: 'monospace',
    letterSpacing: 2.0,
  );

  // Death / success message
  static const TextStyle resultMessage = TextStyle(
    color: AppColors.textPrimary,
    fontSize: AppDimensions.fontL,
    height: 1.7,
    fontFamily: 'monospace',
  );
}
