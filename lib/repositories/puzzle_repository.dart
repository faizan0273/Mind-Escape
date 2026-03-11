/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Repository for creating and managing active PuzzleModel
                instances. Acts as a factory for puzzle state during gameplay.

---------------------------------------------------
*/

import 'package:cipher_escape/models/level_model.dart';
import 'package:cipher_escape/models/puzzle_model.dart';

class PuzzleRepository {
  /// Creates a fresh puzzle from a level.
  PuzzleModel createFromLevel(LevelModel level) {
    return PuzzleModel(
      levelId: level.id,
      cipherType: level.cipherType,
      encryptedMessage: level.encryptedMessage,
      decodedMessage: level.decodedMessage,
    );
  }

  /// Returns all three hints for a level as an ordered list.
  List<String> getHints(LevelModel level) => [
        level.hint1,
        level.hint2,
        level.hint3,
      ];

  /// Returns a specific hint (1-indexed).
  String getHint(LevelModel level, int hintNumber) {
    switch (hintNumber) {
      case 1:
        return level.hint1;
      case 2:
        return level.hint2;
      case 3:
        return level.hint3;
      default:
        return '';
    }
  }
}
