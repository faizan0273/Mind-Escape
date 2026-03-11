/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Repository providing access to player state and
                player-related operations, abstracting GameStateManager.

---------------------------------------------------
*/

import 'package:get/get.dart';
import 'package:cipher_escape/engine/game_state_manager.dart';
import 'package:cipher_escape/models/player_model.dart';

class PlayerRepository {
  final GameStateManager _state = Get.find<GameStateManager>();

  PlayerModel get player => _state.player.value;

  int get coins => player.coins;
  int get xp => player.xp;
  int get lives => player.lives;
  bool get hasLives => _state.hasLives;

  Future<void> addCoins(int amount) => _state.addCoins(amount);
  Future<bool> spendCoins(int amount) => _state.spendCoins(amount);
  Future<void> addXp(int amount) => _state.addXp(amount);
  Future<void> loseLife() => _state.loseLife();
  Future<void> restoreLives([int count = 1]) => _state.restoreLives(count);
  Future<void> unlockAchievement(String id) => _state.unlockAchievement(id);

  bool hasAchievement(String id) => player.hasAchievement(id);
  List<String> get achievements => player.achievements;
}
