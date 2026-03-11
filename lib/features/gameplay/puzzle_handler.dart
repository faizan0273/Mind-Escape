/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    PuzzleHandler processes player choice submissions,
                determines win/lose outcomes, and delegates results
                to the GameController.

---------------------------------------------------
*/

import 'package:cipher_escape/models/level_model.dart';
import 'package:cipher_escape/models/puzzle_model.dart';

class PuzzleHandler {
  /// Evaluates a player's choice against the puzzle's correct answer.
  /// Returns true if correct, false otherwise.
  bool evaluateChoice(PuzzleModel puzzle, ChoiceModel choice) {
    final correct = choice.isCorrect;
    if (correct) {
      puzzle.markSolved();
    } else {
      puzzle.markFailed();
    }
    return correct;
  }

  /// Returns the correct choice from a list of choices.
  ChoiceModel? getCorrectChoice(List<ChoiceModel> choices) {
    try {
      return choices.firstWhere((c) => c.isCorrect);
    } catch (_) {
      return null;
    }
  }

  /// Validates the integrity of a level's choices (exactly one correct).
  bool validateLevel(LevelModel level) {
    final correctCount = level.choices.where((c) => c.isCorrect).length;
    return correctCount == 1 && level.choices.length == 3;
  }
}
