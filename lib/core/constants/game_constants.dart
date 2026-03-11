/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Game-wide constants including cipher types, difficulty labels,
                storage keys, route names, and reward settings.

---------------------------------------------------
*/

class GameConstants {
  GameConstants._();

  // Cipher types
  static const String cipherBinary = 'binary';
  static const String cipherMorse = 'morse';
  static const String cipherCaesar = 'caesar';
  static const String cipherEmoji = 'emoji';
  static const String cipherNumber = 'number';

  // Difficulty keys
  static const String difficultyEasy = 'easy';
  static const String difficultyMedium = 'medium';
  static const String difficultyHard = 'hard';

  // Sender types
  static const String senderHelper = 'Helper';
  static const String senderOverseer = 'Overseer AI';
  static const String senderFuture = 'Future Self';
  static const String senderGhost = 'Past Prisoner';
  static const String senderUnknown = 'Unknown';

  // Game rules
  static const int defaultLives = 3;
  /// Default time limit (seconds) for every level when level has no time_limit. If crossed, player loses a life.
  static const int defaultLevelTimeLimit = 90;
  static const int maxHintsPerLevel = 3;
  static const int hint1Cost = 0;
  static const int hint2Cost = 10;
  static const int hint3Cost = 20;
  static const int perfectLevelBonus = 20;
  static const int noHintsBonus = 15;

  // SharedPreferences keys
  static const String keyPlayerCoins = 'player_coins';
  static const String keyPlayerXp = 'player_xp';
  static const String keyPlayerLives = 'player_lives';
  static const String keyCurrentLevel = 'current_level';
  static const String keyCompletedLevels = 'completed_levels';
  static const String keyAchievements = 'achievements';
  static const String keySoundEnabled = 'sound_enabled';
  static const String keyMusicEnabled = 'music_enabled';

  // Mystery / Archive / Progression
  static const String keyMysteryHookSeen = 'mystery_hook_seen';
  static const String keyArchiveUnlocked = 'archive_unlocked';
  static const String keyStoryFilesUnlocked = 'story_files_unlocked';
  static const String keyEndingsDiscovered = 'endings_discovered';
  static const String keyCurrentStreak = 'current_streak';
  static const String keyLastCompletedLevelId = 'last_completed_level_id';
  static const String keyDailyPuzzleLastPlayedDate = 'daily_puzzle_last_date';
  static const String keyWalletBalanceCents = 'wallet_balance_cents';

  static const int totalEndings = 7;
  static const int mysteryHookLevel = 3;
  /// Wallet: earn this many cents ($5) each time user completes all levels.
  static const int walletEarnPerCompletionCents = 500;
  /// Wallet: user can withdraw when balance reaches this many cents ($50).
  static const int walletWithdrawThresholdCents = 5000;

  // Cipher tools unlock at these levels (inclusive)
  static const Map<String, int> cipherUnlockLevels = {
    cipherBinary: 1,
    cipherMorse: 2,
    cipherNumber: 4,
    cipherCaesar: 7,
    cipherEmoji: 12,
  };

  // Named routes
  static const String routeHome = '/home';
  static const String routeGame = '/game';
  static const String routeResult = '/result';
  static const String routeStore = '/store';
  static const String routeLevelSelect = '/level-select';
  static const String routeAchievements = '/achievements';
  static const String routeMysteryHook = '/mystery-hook';
  static const String routeArchive = '/archive';
  static const String routeWallet = '/wallet';

  // Chapter titles (story progression)
  static const String chapter1Title = 'The Nexus';
  static const String chapter2Title = 'The Archive';
  static const String chapter3Title = 'The Overseer';
  static String chapterTitleForPhase(int phase) {
    switch (phase) {
      case 1: return chapter1Title;
      case 2: return chapter2Title;
      case 3: return chapter3Title;
      default: return 'Unknown';
    }
  }

  // Achievement IDs
  static const String achievementFirstEscape = 'first_escape';
  static const String achievementBinaryExpert = 'binary_expert';
  static const String achievementMorseMaster = 'morse_master';
  static const String achievementSpeedRunner = 'speed_runner';
  static const String achievementNoHints = 'no_hints_used';
  static const String achievementMasterDecoder = 'master_decoder';
  static const String achievementPhase1 = 'phase_1_complete';
  static const String achievementPhase2 = 'phase_2_complete';
  static const String achievementPhase3 = 'phase_3_complete';

  // Level count per difficulty
  static const int easyLevelCount = 10;
  static const int mediumLevelCount = 10;
  static const int hardLevelCount = 10;
  static const int totalLevels = 30;

  // Asset paths
  static const String levelsEasyPath = 'assets/levels/levels_easy.json';
  static const String levelsMediumPath = 'assets/levels/levels_medium.json';
  static const String levelsHardPath = 'assets/levels/levels_hard.json';
}
