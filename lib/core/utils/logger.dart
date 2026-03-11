/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Simple debug logger utility. Outputs tagged log messages
                to the console only in debug builds.

---------------------------------------------------
*/

import 'package:flutter/foundation.dart';

class AppLogger {
  AppLogger._();

  static void info(String tag, String message) {
    if (kDebugMode) {
      debugPrint('[INFO][$tag] $message');
    }
  }

  static void warning(String tag, String message) {
    if (kDebugMode) {
      debugPrint('[WARN][$tag] $message');
    }
  }

  static void error(String tag, String message, [Object? error]) {
    if (kDebugMode) {
      debugPrint('[ERROR][$tag] $message');
      if (error != null) debugPrint('  └─ $error');
    }
  }

  static void debug(String tag, String message) {
    if (kDebugMode) {
      debugPrint('[DEBUG][$tag] $message');
    }
  }
}
