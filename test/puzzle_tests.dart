/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Unit tests for PuzzleModel and PuzzleHandler logic
                including choice evaluation, hint tracking, and state.

---------------------------------------------------
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:cipher_escape/models/level_model.dart';
import 'package:cipher_escape/models/puzzle_model.dart';
import 'package:cipher_escape/features/gameplay/puzzle_handler.dart';

void main() {
  group('PuzzleModel', () {
    late PuzzleModel puzzle;

    setUp(() {
      puzzle = PuzzleModel(
        levelId: 1,
        cipherType: 'binary',
        encryptedMessage: '01001100 01000101 01000110 01010100',
        decodedMessage: 'LEFT',
      );
    });

    test('initial state is unsolved and unfailed', () {
      expect(puzzle.isSolved, isFalse);
      expect(puzzle.isFailed, isFalse);
      expect(puzzle.hintsUsed, 0);
    });

    test('markSolved sets isSolved to true', () {
      puzzle.markSolved();
      expect(puzzle.isSolved, isTrue);
      expect(puzzle.isFailed, isFalse);
    });

    test('markFailed sets isFailed to true', () {
      puzzle.markFailed();
      expect(puzzle.isFailed, isTrue);
      expect(puzzle.isSolved, isFalse);
    });

    test('solvedPerfectly is true when solved with no hints', () {
      puzzle.markSolved();
      expect(puzzle.solvedPerfectly, isTrue);
    });

    test('solvedPerfectly is false when hints were used', () {
      puzzle.useHint();
      puzzle.markSolved();
      expect(puzzle.solvedPerfectly, isFalse);
    });

    test('useHint increments hintsUsed', () {
      puzzle.useHint();
      expect(puzzle.hintsUsed, 1);
      puzzle.useHint();
      expect(puzzle.hintsUsed, 2);
    });
  });

  group('PuzzleHandler', () {
    final handler = PuzzleHandler();

    final choices = [
      const ChoiceModel(id: 1, text: 'Open Left Door', isCorrect: true),
      const ChoiceModel(id: 2, text: 'Open Right Door', isCorrect: false),
      const ChoiceModel(id: 3, text: 'Jump Window', isCorrect: false),
    ];

    late PuzzleModel puzzle;

    setUp(() {
      puzzle = PuzzleModel(
        levelId: 1,
        cipherType: 'binary',
        encryptedMessage: '01001100 01000101 01000110 01010100',
        decodedMessage: 'LEFT',
      );
    });

    test('evaluateChoice returns true for correct choice', () {
      final result = handler.evaluateChoice(puzzle, choices[0]);
      expect(result, isTrue);
      expect(puzzle.isSolved, isTrue);
    });

    test('evaluateChoice returns false for wrong choice', () {
      final result = handler.evaluateChoice(puzzle, choices[1]);
      expect(result, isFalse);
      expect(puzzle.isFailed, isTrue);
    });

    test('getCorrectChoice returns the correct choice', () {
      final correct = handler.getCorrectChoice(choices);
      expect(correct?.id, 1);
      expect(correct?.isCorrect, isTrue);
    });
  });
}
