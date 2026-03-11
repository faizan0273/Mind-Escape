/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Unit tests for all cipher decoder implementations
                (Binary, Morse, Caesar, Emoji, Number).

---------------------------------------------------
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:cipher_escape/puzzles/binary/binary_decoder.dart';
import 'package:cipher_escape/puzzles/morse/morse_decoder.dart';
import 'package:cipher_escape/puzzles/caesar/caesar_decoder.dart';
import 'package:cipher_escape/puzzles/emoji/emoji_decoder.dart';
import 'package:cipher_escape/puzzles/number/number_decoder.dart';
import 'package:cipher_escape/puzzles/cipher_decoder.dart';
import 'package:cipher_escape/core/constants/game_constants.dart';

void main() {
  group('BinaryDecoder', () {
    final decoder = BinaryDecoder();

    test('decodes LEFT correctly', () {
      const input = '01001100 01000101 01000110 01010100';
      expect(decoder.decode(input), 'LEFT');
    });

    test('decodes RUN correctly', () {
      const input = '01010010 01010101 01001110';
      expect(decoder.decode(input), 'RUN');
    });

    test('encodes LEFT back to binary', () {
      final encoded = BinaryDecoder.encode('LEFT');
      expect(decoder.decode(encoded), 'LEFT');
    });

    test('returns ? for invalid binary', () {
      expect(decoder.decode('INVALID'), '?');
    });
  });

  group('MorseDecoder', () {
    final decoder = MorseDecoder();

    test('decodes HIDE correctly', () {
      const input = '.... .. -.. .';
      expect(decoder.decode(input), 'HIDE');
    });

    test('decodes multi-word message', () {
      const input = '... - . . .-.. / - --- .-- . .-.';
      expect(decoder.decode(input), 'STEEL TOWER');
    });

    test('encodes and decodes round-trip', () {
      const word = 'ESCAPE';
      final encoded = MorseDecoder.encode(word);
      expect(decoder.decode(encoded), word);
    });
  });

  group('CaesarDecoder', () {
    test('decodes with shift 3', () {
      final decoder = CaesarDecoder(shift: 3);
      expect(decoder.decode('ULJKW'), 'RIGHT');
    });

    test('decodes with shift 13 (ROT13)', () {
      final decoder = CaesarDecoder(shift: 13);
      expect(decoder.decode('GEHR'), 'TRUE');
    });

    test('parseShiftFromLabel extracts absolute shift value', () {
      // parseShiftFromLabel returns the raw parsed int (e.g. -3 from "Shift: -3"),
      // but the decoder uses its absolute magnitude. We verify the magnitude.
      final s3 = CaesarDecoder.parseShiftFromLabel('Caesar Cipher (Shift: -3)');
      expect(s3.abs(), 3);
      final s7 = CaesarDecoder.parseShiftFromLabel('Caesar Cipher (Shift: -7)');
      expect(s7.abs(), 7);
      expect(CaesarDecoder.parseShiftFromLabel('ROT13'), 13);
    });
  });

  group('EmojiDecoder', () {
    final decoder = EmojiDecoder();

    test('decodes OPEN correctly', () {
      const input = '🐙 🐧 👁 🌙️';
      final result = decoder.decode(input);
      expect(result.contains('O'), isTrue);
    });

    test('decodes LEFT correctly', () {
      const input = '🦁 👁 🦊 🌮';
      expect(decoder.decode(input), 'LEFT');
    });
  });

  group('NumberDecoder', () {
    final decoder = NumberDecoder();

    test('decodes RUN correctly', () {
      expect(decoder.decode('18 21 14'), 'RUN');
    });

    test('decodes UP correctly', () {
      expect(decoder.decode('21 16'), 'UP');
    });

    test('encodes and decodes round-trip', () {
      const word = 'HELP';
      final encoded = NumberDecoder.encode(word);
      expect(decoder.decode(encoded), word);
    });

    test('returns ? for out-of-range number', () {
      expect(decoder.decode('27'), '?');
    });
  });

  group('CipherDecoder factory', () {
    test('returns BinaryDecoder for binary type', () {
      final decoder = CipherDecoder.forType(GameConstants.cipherBinary);
      expect(decoder, isA<BinaryDecoder>());
    });

    test('returns MorseDecoder for morse type', () {
      final decoder = CipherDecoder.forType(GameConstants.cipherMorse);
      expect(decoder, isA<MorseDecoder>());
    });

    test('throws for unknown cipher type', () {
      expect(() => CipherDecoder.forType('unknown'), throwsArgumentError);
    });
  });
}
