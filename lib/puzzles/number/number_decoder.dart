/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Number cipher decoder. Converts numbers to letters
                using A=1, B=2, C=3 ... Z=26 mapping.
                Example: 18 21 14 → RUN

---------------------------------------------------
*/

import 'package:cipher_escape/puzzles/cipher_decoder.dart';

class NumberDecoder extends CipherDecoder {
  @override
  String get cipherName => 'Number Code';

  @override
  String decode(String encoded) {
    try {
      final parts = encoded.trim().split(RegExp(r'\s+'));
      final buffer = StringBuffer();
      for (final part in parts) {
        if (part.isEmpty) continue;
        final n = int.parse(part);
        if (n >= 1 && n <= 26) {
          buffer.writeCharCode(64 + n);
        } else {
          buffer.write('?');
        }
      }
      return buffer.toString();
    } catch (_) {
      return '?';
    }
  }

  /// Encodes plain text to space-separated number sequence.
  static String encode(String text) {
    return text.toUpperCase().split('').map((c) {
      final code = c.codeUnitAt(0);
      if (code >= 65 && code <= 90) return (code - 64).toString();
      return '?';
    }).join(' ');
  }

  @override
  String get referenceGuide => '''
Number Code Reference (A=1, B=2 ... Z=26):
A=1   B=2   C=3   D=4   E=5   F=6   G=7
H=8   I=9   J=10  K=11  L=12  M=13  N=14
O=15  P=16  Q=17  R=18  S=19  T=20  U=21
V=22  W=23  X=24  Y=25  Z=26''';
}
