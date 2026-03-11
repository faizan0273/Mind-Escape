/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Simple event bus for decoupled communication between
                game components (engine, controllers, UI).

---------------------------------------------------
*/

import 'dart:async';
import 'package:get/get.dart';

enum GameEvent {
  levelStarted,
  levelCompleted,
  levelFailed,
  hintUsed,
  playerDied,
  livesRestored,
  achievementUnlocked,
  coinsUpdated,
  xpUpdated,
  timerTick,
  timerExpired,
}

class GameEventData {
  final GameEvent event;
  final Map<String, dynamic> payload;

  const GameEventData(this.event, [this.payload = const {}]);
}

class EventBus extends GetxService {
  final _controller = StreamController<GameEventData>.broadcast();

  Stream<GameEventData> get stream => _controller.stream;

  void emit(GameEvent event, [Map<String, dynamic> payload = const {}]) {
    if (!_controller.isClosed) {
      _controller.add(GameEventData(event, payload));
    }
  }

  StreamSubscription<GameEventData> on(
    GameEvent event,
    void Function(GameEventData) handler,
  ) {
    return stream.where((e) => e.event == event).listen(handler);
  }

  @override
  void onClose() {
    _controller.close();
    super.onClose();
  }
}
