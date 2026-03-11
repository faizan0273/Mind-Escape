/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Reward and Achievement models used to represent
                level completion rewards and unlockable achievements.

---------------------------------------------------
*/

import 'package:cipher_escape/core/constants/game_constants.dart';

class RewardModel {
  final int coins;
  final int xp;
  final bool noHintsBonus;
  final bool perfectBonus;
  final String? unlockedAchievement;

  const RewardModel({
    required this.coins,
    required this.xp,
    this.noHintsBonus = false,
    this.perfectBonus = false,
    this.unlockedAchievement,
  });

  int get totalCoins {
    int total = coins;
    if (noHintsBonus) total += GameConstants.noHintsBonus;
    if (perfectBonus) total += GameConstants.perfectLevelBonus;
    return total;
  }

  factory RewardModel.forLevel({
    required int baseCoins,
    required int baseXp,
    required int hintsUsed,
    required bool timedSuccess,
  }) {
    final noHints = hintsUsed == 0;
    final perfect = noHints && timedSuccess;
    return RewardModel(
      coins: baseCoins,
      xp: baseXp,
      noHintsBonus: noHints,
      perfectBonus: perfect,
    );
  }
}

class AchievementModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  bool isUnlocked;

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
  });

  static List<AchievementModel> get all => [
        AchievementModel(
          id: GameConstants.achievementFirstEscape,
          title: 'First Escape',
          description: 'Complete your first level.',
          icon: '🔓',
        ),
        AchievementModel(
          id: GameConstants.achievementBinaryExpert,
          title: 'Binary Expert',
          description: 'Complete 3 binary cipher levels.',
          icon: '💻',
        ),
        AchievementModel(
          id: GameConstants.achievementMorseMaster,
          title: 'Morse Master',
          description: 'Complete your first Morse code level.',
          icon: '📡',
        ),
        AchievementModel(
          id: GameConstants.achievementSpeedRunner,
          title: 'Speed Runner',
          description: 'Complete a timed level with 10+ seconds remaining.',
          icon: '⚡',
        ),
        AchievementModel(
          id: GameConstants.achievementNoHints,
          title: 'No Hints Needed',
          description: 'Complete 5 levels without using any hints.',
          icon: '🧠',
        ),
        AchievementModel(
          id: GameConstants.achievementMasterDecoder,
          title: 'Master Decoder',
          description: 'Complete all 30 levels.',
          icon: '🏆',
        ),
        AchievementModel(
          id: GameConstants.achievementPhase1,
          title: 'Phase 1 Complete',
          description: 'Escape The Nexus (levels 1–10).',
          icon: '🏃',
        ),
        AchievementModel(
          id: GameConstants.achievementPhase2,
          title: 'Phase 2 Complete',
          description: 'Infiltrate The Archive (levels 11–20).',
          icon: '📚',
        ),
        AchievementModel(
          id: GameConstants.achievementPhase3,
          title: 'Phase 3 Complete',
          description: 'Defeat the Overseer (levels 21–30).',
          icon: '🤖',
        ),
      ];
}
