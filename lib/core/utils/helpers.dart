/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    General utility helper functions for formatting, validation,
                and game-specific calculations.

---------------------------------------------------
*/

import 'package:cipher_escape/core/constants/game_constants.dart';
import 'package:flutter/material.dart';
import 'package:cipher_escape/core/constants/colors.dart';

class AppHelpers {
  AppHelpers._();

  /// Returns a display-friendly name for a cipher type key.
  static String cipherTypeName(String type) {
    switch (type) {
      case GameConstants.cipherBinary:
        return 'Binary Code';
      case GameConstants.cipherMorse:
        return 'Morse Code';
      case GameConstants.cipherCaesar:
        return 'Caesar Cipher';
      case GameConstants.cipherEmoji:
        return 'Emoji Cipher';
      case GameConstants.cipherNumber:
        return 'Number Code';
      default:
        return 'Unknown Cipher';
    }
  }

  /// Returns an icon for a cipher type.
  static IconData cipherTypeIcon(String type) {
    switch (type) {
      case GameConstants.cipherBinary:
        return Icons.data_array;
      case GameConstants.cipherMorse:
        return Icons.radio;
      case GameConstants.cipherCaesar:
        return Icons.rotate_right;
      case GameConstants.cipherEmoji:
        return Icons.emoji_emotions;
      case GameConstants.cipherNumber:
        return Icons.pin;
      default:
        return Icons.lock;
    }
  }

  /// Returns a color for a sender type.
  static Color senderColor(String sender) {
    switch (sender) {
      case GameConstants.senderHelper:
        return AppColors.senderHelper;
      case GameConstants.senderOverseer:
        return AppColors.senderEnemy;
      case GameConstants.senderFuture:
        return AppColors.senderFuture;
      case GameConstants.senderGhost:
        return AppColors.senderGhost;
      default:
        return AppColors.senderUnknown;
    }
  }

  /// Returns a display color for difficulty.
  static Color difficultyColor(String difficulty) {
    switch (difficulty) {
      case GameConstants.difficultyEasy:
        return AppColors.difficultyEasy;
      case GameConstants.difficultyMedium:
        return AppColors.difficultyMedium;
      case GameConstants.difficultyHard:
        return AppColors.difficultyHard;
      default:
        return AppColors.textSecondary;
    }
  }

  /// Formats seconds into MM:SS string.
  static String formatTimer(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// Calculates XP needed for the next level tier.
  static int xpForNextTier(int currentXp) {
    return ((currentXp ~/ 100) + 1) * 100;
  }

  /// Returns phase label (1, 2, or 3) for a level id.
  static int phaseForLevel(int levelId) {
    if (levelId <= 10) return 1;
    if (levelId <= 20) return 2;
    return 3;
  }
}
