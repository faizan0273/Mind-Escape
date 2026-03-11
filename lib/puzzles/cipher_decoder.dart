/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Abstract base class for all cipher decoders in
                Cipher Escape. Also provides a factory to get the
                correct decoder for a given cipher type.

---------------------------------------------------
*/

import 'package:cipher_escape/core/constants/game_constants.dart';
import 'package:cipher_escape/puzzles/binary/binary_decoder.dart';
import 'package:cipher_escape/puzzles/caesar/caesar_decoder.dart';
import 'package:cipher_escape/puzzles/emoji/emoji_decoder.dart';
import 'package:cipher_escape/puzzles/morse/morse_decoder.dart';
import 'package:cipher_escape/puzzles/number/number_decoder.dart';

abstract class CipherDecoder {
  /// Decodes the given [encoded] string to plain text.
  String decode(String encoded);

  /// Returns a reference/guide string to help the player decode manually.
  String get referenceGuide;

  /// Returns the display name of this cipher type.
  String get cipherName;

  /// Factory method to get the appropriate decoder for a cipher type key.
  static CipherDecoder forType(String type) {
    switch (type) {
      case GameConstants.cipherBinary:
        return BinaryDecoder();
      case GameConstants.cipherMorse:
        return MorseDecoder();
      case GameConstants.cipherCaesar:
        return CaesarDecoder();
      case GameConstants.cipherEmoji:
        return EmojiDecoder();
      case GameConstants.cipherNumber:
        return NumberDecoder();
      default:
        throw ArgumentError('Unknown cipher type: $type');
    }
  }
}
