/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    PuzzleModel represents a single active puzzle state
                during gameplay, tracking hints used and solve status.

---------------------------------------------------
*/

class PuzzleModel {
  final int levelId;
  final String cipherType;
  final String encryptedMessage;
  final String decodedMessage;
  int hintsUsed;
  bool isSolved;
  bool isFailed;

  PuzzleModel({
    required this.levelId,
    required this.cipherType,
    required this.encryptedMessage,
    required this.decodedMessage,
    this.hintsUsed = 0,
    this.isSolved = false,
    this.isFailed = false,
  });

  /// Whether the player solved without using any hints.
  bool get solvedPerfectly => isSolved && hintsUsed == 0;

  /// Returns the hint string for the given hint number (1, 2, or 3).
  /// The actual hint text is stored on LevelModel; this tracks usage.
  bool canUseHint(int hintNumber) => hintsUsed < hintNumber;

  void markSolved() {
    isSolved = true;
    isFailed = false;
  }

  void markFailed() {
    isFailed = true;
    isSolved = false;
  }

  void useHint() {
    hintsUsed++;
  }

  PuzzleModel copyWith({
    int? hintsUsed,
    bool? isSolved,
    bool? isFailed,
  }) {
    return PuzzleModel(
      levelId: levelId,
      cipherType: cipherType,
      encryptedMessage: encryptedMessage,
      decodedMessage: decodedMessage,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      isSolved: isSolved ?? this.isSolved,
      isFailed: isFailed ?? this.isFailed,
    );
  }
}
