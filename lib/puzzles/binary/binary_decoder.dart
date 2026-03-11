/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Binary cipher decoder. Converts space-separated 8-bit
                binary groups to their ASCII letter equivalents.
                Example: 01001100 → L

---------------------------------------------------
*/

import 'package:cipher_escape/puzzles/cipher_decoder.dart';

class BinaryDecoder extends CipherDecoder {
  @override
  String get cipherName => 'Binary Code';

  @override
  String decode(String encoded) {
    try {
      final groups = encoded.trim().split(RegExp(r'\s+'));
      final buffer = StringBuffer();
      for (final group in groups) {
        if (group.isEmpty) continue;
        final charCode = int.parse(group, radix: 2);
        buffer.writeCharCode(charCode);
      }
      return buffer.toString();
    } catch (_) {
      return '?';
    }
  }

  @override
  String get referenceGuide => '''
Binary Code Reference:
Each 8-digit group = 1 letter
A = 01000001   N = 01001110
B = 01000010   O = 01001111
C = 01000011   P = 01010000
D = 01000100   Q = 01010001
E = 01000101   R = 01010010
F = 01000110   S = 01010011
G = 01000111   T = 01010100
H = 01001000   U = 01010101
I = 01001001   V = 01010110
J = 01001010   W = 01010111
K = 01001011   X = 01011000
L = 01001100   Y = 01011001
M = 01001101   Z = 01011010''';

  /// Encodes plain text to binary representation.
  static String encode(String text) {
    return text.toUpperCase().split('').map((c) {
      return c.codeUnitAt(0).toRadixString(2).padLeft(8, '0');
    }).join(' ');
  }
}
