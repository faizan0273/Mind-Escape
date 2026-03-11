/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Unit tests for LevelModel parsing, validation, and
                helper properties (phase, correctChoice, etc.).

---------------------------------------------------
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:cipher_escape/models/level_model.dart';
import 'package:cipher_escape/features/gameplay/puzzle_handler.dart';

void main() {
  group('LevelModel.fromJson', () {
    final json = {
      'id': 1,
      'difficulty': 'easy',
      'title': 'Awakening',
      'story': 'You open your eyes...',
      'sender': 'Helper',
      'sender_icon': '🟢',
      'cipher_type': 'binary',
      'cipher_label': 'Binary Code',
      'encrypted_message': '01001100 01000101 01000110 01010100',
      'decoded_message': 'LEFT',
      'is_timed': false,
      'time_limit': null,
      'is_multi_layer': false,
      'choices': [
        {'id': 1, 'text': 'Open Left Door', 'is_correct': true},
        {'id': 2, 'text': 'Open Right Door', 'is_correct': false},
        {'id': 3, 'text': 'Jump Window', 'is_correct': false},
      ],
      'death_message': 'Wrong door.',
      'success_message': 'You escaped!',
      'hint1': 'Hint 1',
      'hint2': 'Hint 2',
      'hint3': 'Hint 3',
      'reward_coins': 10,
      'reward_xp': 5,
    };

    test('parses all fields correctly', () {
      final level = LevelModel.fromJson(json);
      expect(level.id, 1);
      expect(level.title, 'Awakening');
      expect(level.cipherType, 'binary');
      expect(level.choices.length, 3);
      expect(level.isTimed, isFalse);
    });

    test('phase returns 1 for levels 1-10', () {
      final level = LevelModel.fromJson(json);
      expect(level.phase, 1);
    });

    test('phase returns 2 for levels 11-20', () {
      final level = LevelModel.fromJson({...json, 'id': 15});
      expect(level.phase, 2);
    });

    test('phase returns 3 for levels 21-30', () {
      final level = LevelModel.fromJson({...json, 'id': 25});
      expect(level.phase, 3);
    });

    test('correctChoice returns the right choice', () {
      final level = LevelModel.fromJson(json);
      expect(level.correctChoice?.id, 1);
      expect(level.correctChoice?.isCorrect, isTrue);
    });
  });

  group('PuzzleHandler.validateLevel', () {
    final handler = PuzzleHandler();

    test('valid level with exactly one correct choice passes', () {
      final level = LevelModel.fromJson({
        'id': 1,
        'difficulty': 'easy',
        'title': 'Test',
        'story': 'Test story',
        'sender': 'Helper',
        'sender_icon': '🟢',
        'cipher_type': 'binary',
        'cipher_label': 'Binary',
        'encrypted_message': '...',
        'decoded_message': 'TEST',
        'is_timed': false,
        'time_limit': null,
        'is_multi_layer': false,
        'choices': [
          {'id': 1, 'text': 'A', 'is_correct': true},
          {'id': 2, 'text': 'B', 'is_correct': false},
          {'id': 3, 'text': 'C', 'is_correct': false},
        ],
        'death_message': 'Dead',
        'success_message': 'Win',
        'hint1': '', 'hint2': '', 'hint3': '',
        'reward_coins': 10,
        'reward_xp': 5,
      });
      expect(handler.validateLevel(level), isTrue);
    });
  });
}
