/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    [FUTURE FEATURE] MultiplayerService stub for real-time
                multiplayer cipher battles. Players race to decode the
                same cipher and choose the correct action first.
                Planned to use WebSocket or Firebase Realtime Database.

---------------------------------------------------
*/

import 'package:get/get.dart';
import 'package:cipher_escape/core/utils/logger.dart';

class MultiplayerService extends GetxService {
  static const _tag = 'MultiplayerService';

  final RxBool isConnected = false.obs;
  final RxString roomCode = ''.obs;
  final RxInt playersInRoom = 0.obs;

  @override
  void onInit() {
    super.onInit();
    AppLogger.info(_tag, 'MultiplayerService stub initialized (future feature)');
  }

  Future<void> connect() async {
    AppLogger.info(_tag, 'connect() — not yet implemented');
  }

  Future<void> createRoom() async {
    AppLogger.info(_tag, 'createRoom() — not yet implemented');
  }

  Future<void> joinRoom(String code) async {
    AppLogger.info(_tag, 'joinRoom($code) — not yet implemented');
  }

  Future<void> disconnect() async {
    AppLogger.info(_tag, 'disconnect() — not yet implemented');
  }
}
