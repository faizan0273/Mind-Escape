/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    [FUTURE FEATURE] RoomManager stub for managing multiplayer
                game rooms. Handles player joining, leaving, and game
                state synchronization in real-time rooms.

---------------------------------------------------
*/

import 'package:get/get.dart';
import 'package:cipher_escape/core/utils/logger.dart';

class RoomManager extends GetxController {
  static const _tag = 'RoomManager';

  final RxList<String> players = <String>[].obs;
  final RxBool gameStarted = false.obs;
  final RxString hostId = ''.obs;

  void addPlayer(String playerId) {
    AppLogger.info(_tag, 'addPlayer($playerId) — not yet implemented');
  }

  void removePlayer(String playerId) {
    AppLogger.info(_tag, 'removePlayer($playerId) — not yet implemented');
  }

  void startGame() {
    AppLogger.info(_tag, 'startGame() — not yet implemented');
  }

  void endGame() {
    AppLogger.info(_tag, 'endGame() — not yet implemented');
  }
}
