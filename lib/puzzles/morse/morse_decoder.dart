/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Morse code cipher decoder. Converts dot-dash patterns
                to letters. Letters separated by spaces, words by " / ".
                Example: .... .. -.. . → HIDE

---------------------------------------------------
*/

import 'package:cipher_escape/puzzles/cipher_decoder.dart';

class MorseDecoder extends CipherDecoder {
  static const Map<String, String> _morseTable = {
    '.-': 'A', '-...': 'B', '-.-.': 'C', '-..': 'D',
    '.': 'E', '..-.': 'F', '--.': 'G', '....': 'H',
    '..': 'I', '.---': 'J', '-.-': 'K', '.-..': 'L',
    '--': 'M', '-.': 'N', '---': 'O', '.--.': 'P',
    '--.-': 'Q', '.-.': 'R', '...': 'S', '-': 'T',
    '..-': 'U', '...-': 'V', '.--': 'W', '-..-': 'X',
    '-.--': 'Y', '--..': 'Z',
    '-----': '0', '.----': '1', '..---': '2', '...--': '3',
    '....-': '4', '.....': '5', '-....': '6', '--...': '7',
    '---..': '8', '----.': '9',
  };

  @override
  String get cipherName => 'Morse Code';

  @override
  String decode(String encoded) {
    try {
      final words = encoded.trim().split(' / ');
      final buffer = StringBuffer();
      for (int wi = 0; wi < words.length; wi++) {
        if (wi > 0) buffer.write(' ');
        final letters = words[wi].trim().split(' ');
        for (final letter in letters) {
          if (letter.isEmpty) continue;
          buffer.write(_morseTable[letter] ?? '?');
        }
      }
      return buffer.toString();
    } catch (_) {
      return '?';
    }
  }

  @override
  String get referenceGuide => '''
Morse Code Reference:
A .-    B -...  C -.-.  D -..
E .     F ..-.  G --.   H ....
I ..    J .---  K -.-   L .-..
M --    N -.    O ---   P .--.
Q --.-  R .-.   S ...   T -
U ..-   V ...-  W .--   X -..-
Y -.--  Z --..

(Letters separated by spaces, words by " / ")''';

  /// Encodes plain text to Morse code.
  static String encode(String text) {
    final reversed = {for (final e in _morseTable.entries) e.value: e.key};
    return text.toUpperCase().split('').map((c) {
      if (c == ' ') return '/';
      return reversed[c] ?? '?';
    }).join(' ');
  }
}
