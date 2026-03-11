/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Emoji cipher decoder. Maps specific emojis to letters
                of the alphabet. Decodes a space-separated sequence of
                emojis into plain text.

---------------------------------------------------
*/

import 'package:cipher_escape/puzzles/cipher_decoder.dart';

class EmojiDecoder extends CipherDecoder {
  static const Map<String, String> _emojiTable = {
    '🍎': 'A', '🐝': 'B', '🌙': 'C', '🐬': 'D', '👁': 'E',
    '🦊': 'F', '🎸': 'G', '🏠': 'H', '🍦': 'I', '🎷': 'J',
    '🔑': 'K', '🦁': 'L', '🌕': 'M', '🌙️': 'N', '🐙': 'O',
    '🐧': 'P', '👑': 'Q', '🌹': 'R', '⭐': 'S', '🌮': 'T',
    '☂️': 'U', '🎻': 'V', '🌊': 'W', '❌': 'X', '🌼': 'Y',
    '⚡': 'Z',
  };

  // Reversed map for encoding
  static final Map<String, String> _reverseTable = {
    for (final e in _emojiTable.entries) e.value: e.key,
  };

  @override
  String get cipherName => 'Emoji Cipher';

  @override
  String decode(String encoded) {
    try {
      // Split by spaces, but emojis can be multi-character
      final parts = encoded.trim().split(RegExp(r'\s+'));
      final buffer = StringBuffer();
      for (final part in parts) {
        if (part.isEmpty) continue;
        buffer.write(_emojiTable[part] ?? '?');
      }
      return buffer.toString();
    } catch (_) {
      return '?';
    }
  }

  String encode(String text) {
    return text.toUpperCase().split('').map((c) {
      return _reverseTable[c] ?? '?';
    }).join(' ');
  }

  @override
  String get referenceGuide => '''
Emoji Cipher Key:
🍎=A  🐝=B  🌙=C  🐬=D  👁=E
🦊=F  🎸=G  🏠=H  🍦=I  🎷=J
🔑=K  🦁=L  🌕=M  🌙️=N  🐙=O
🐧=P  👑=Q  🌹=R  ⭐=S  🌮=T
☂️=U  🎻=V  🌊=W  ❌=X  🌼=Y
⚡=Z''';

  static Map<String, String> get emojiTable => Map.unmodifiable(_emojiTable);
}
