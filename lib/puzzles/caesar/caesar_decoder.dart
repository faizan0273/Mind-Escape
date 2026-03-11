/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Caesar cipher decoder. Supports configurable shift values.
                Decodes letters by shifting backward in the alphabet.
                Default shift is extracted from the cipher label in the
                level JSON (e.g., "Shift: -3").

---------------------------------------------------
*/

import 'package:cipher_escape/puzzles/cipher_decoder.dart';

class CaesarDecoder extends CipherDecoder {
  final int shift;

  CaesarDecoder({this.shift = 3});

  @override
  String get cipherName => 'Caesar Cipher';

  @override
  String decode(String encoded) {
    return _applyShift(encoded, -shift);
  }

  String encode(String text) {
    return _applyShift(text, shift);
  }

  String _applyShift(String text, int s) {
    final buffer = StringBuffer();
    for (final char in text.toUpperCase().split('')) {
      final code = char.codeUnitAt(0);
      if (code >= 65 && code <= 90) {
        final shifted = ((code - 65 + s) % 26 + 26) % 26 + 65;
        buffer.writeCharCode(shifted);
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  /// Parses the shift value from a cipher label like "Caesar Cipher (Shift: -3)".
  static int parseShiftFromLabel(String label) {
    final match = RegExp(r'Shift:\s*(-?\d+)').firstMatch(label);
    if (match != null) {
      return int.tryParse(match.group(1) ?? '3') ?? 3;
    }
    if (label.contains('ROT13') || label.contains('Shift: -13')) return 13;
    return 3;
  }

  @override
  String get referenceGuide => '''
Caesar Cipher Reference (Shift -$shift):
Original: A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
Encoded:  ${List.generate(26, (i) {
    final c = String.fromCharCode(((i + shift) % 26) + 65);
    return c;
  }).join(' ')}

Each encoded letter maps back $shift positions in the alphabet.''';
}
