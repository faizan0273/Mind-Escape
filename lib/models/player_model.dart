/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    PlayerModel holds the current state of the player
                including coins, XP, lives, and progress data.

---------------------------------------------------
*/

import 'package:cipher_escape/core/constants/game_constants.dart';

class PlayerModel {
  int coins;
  int xp;
  int lives;
  int currentLevel;
  List<int> completedLevels;
  List<String> achievements;

  PlayerModel({
    required this.coins,
    required this.xp,
    required this.lives,
    required this.currentLevel,
    required this.completedLevels,
    required this.achievements,
  });

  factory PlayerModel.initial() => PlayerModel(
        coins: 100,
        xp: 0,
        lives: GameConstants.defaultLives,
        currentLevel: 1,
        completedLevels: [],
        achievements: [],
      );

  /// XP level tier (increases every 100 XP).
  int get xpTier => xp ~/ 100;

  /// Progress within current tier (0.0–1.0).
  double get xpProgress => (xp % 100) / 100.0;

  bool isLevelCompleted(int levelId) => completedLevels.contains(levelId);

  bool isLevelUnlocked(int levelId) {
    if (levelId == 1) return true;
    return completedLevels.contains(levelId - 1);
  }

  bool hasAchievement(String id) => achievements.contains(id);

  PlayerModel copyWith({
    int? coins,
    int? xp,
    int? lives,
    int? currentLevel,
    List<int>? completedLevels,
    List<String>? achievements,
  }) {
    return PlayerModel(
      coins: coins ?? this.coins,
      xp: xp ?? this.xp,
      lives: lives ?? this.lives,
      currentLevel: currentLevel ?? this.currentLevel,
      completedLevels: completedLevels ?? this.completedLevels,
      achievements: achievements ?? this.achievements,
    );
  }
}
