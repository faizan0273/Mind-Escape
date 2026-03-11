/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Dart extension methods for String, int, and BuildContext
                used across the Cipher Escape app.

---------------------------------------------------
*/

import 'package:flutter/material.dart';

extension StringExtensions on String {
  /// Capitalizes the first letter of the string.
  String get capitalized {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Returns true if the string contains only binary characters.
  bool get isBinary => RegExp(r'^[01\s]+$').hasMatch(trim());

  /// Returns true if the string looks like a Morse code string.
  bool get isMorse => RegExp(r'^[.\-\s/]+$').hasMatch(trim());

  /// Truncates the string to [maxLen] characters with an ellipsis.
  String truncate(int maxLen) {
    if (length <= maxLen) return this;
    return '${substring(0, maxLen)}...';
  }
}

extension IntExtensions on int {
  /// Converts seconds to a human-readable countdown string.
  String get asCountdown {
    final m = (this ~/ 60).toString().padLeft(2, '0');
    final s = (this % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// Returns the color for a countdown timer value.
  Color timerColor() {
    if (this > 15) return const Color(0xFF00FF88);
    if (this > 8) return const Color(0xFFFFAA00);
    return const Color(0xFFFF3355);
  }
}

extension ContextExtensions on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get padding => MediaQuery.paddingOf(this);
  bool get isSmallScreen => screenWidth < 360;
  bool get isMediumScreen => screenWidth >= 360 && screenWidth < 400;
  bool get isLargeScreen => screenWidth >= 400;
  ThemeData get theme => Theme.of(this);

  /// Scale factor for responsive sizing (1.0 at 360pt width).
  double get scale => (screenWidth / 360).clamp(0.75, 1.35);

  /// Responsive padding: smaller on narrow screens.
  double responsivePadding(double base) => (base * scale).roundToDouble();

  /// Responsive font size: scales with screen width, clamped.
  double responsiveFontSize(double base) => (base * scale).clamp(base * 0.85, base * 1.2).roundToDouble();
}
