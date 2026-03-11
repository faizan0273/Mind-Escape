/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    App-wide ThemeData for Cipher Escape using a dark,
                terminal-hacker aesthetic with neon cyan and purple accents.

---------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:cipher_escape/core/constants/colors.dart';
import 'package:cipher_escape/core/constants/dimensions.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentCyan,
        secondary: AppColors.accentPurple,
        surface: AppColors.backgroundCard,
        error: AppColors.danger,
        onPrimary: AppColors.backgroundDark,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
      ),
      fontFamily: 'monospace',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppDimensions.fontDisplay,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppDimensions.fontXXL,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppDimensions.fontXL,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppDimensions.fontL,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppDimensions.fontM,
          height: 1.5,
        ),
        labelLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppDimensions.fontL,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.accentCyan,
          fontSize: AppDimensions.fontXL,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
          fontFamily: 'monospace',
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.backgroundCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          side: const BorderSide(color: AppColors.borderColor, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentPurple,
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size(double.infinity, AppDimensions.actionButtonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          textStyle: const TextStyle(
            fontSize: AppDimensions.fontL,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.accentCyan,
        size: AppDimensions.iconM,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderColor,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.backgroundCard,
        contentTextStyle: const TextStyle(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
