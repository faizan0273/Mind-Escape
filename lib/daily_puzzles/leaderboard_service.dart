/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    [FUTURE FEATURE] LeaderboardService stub for global
                and daily leaderboard rankings. Players are ranked by
                XP, levels completed, and daily puzzle streaks.

---------------------------------------------------
*/

import 'package:get/get.dart';
import 'package:cipher_escape/core/utils/logger.dart';

class LeaderboardEntry {
  final String playerName;
  final int rank;
  final int xp;
  final int levelsCompleted;

  const LeaderboardEntry({
    required this.playerName,
    required this.rank,
    required this.xp,
    required this.levelsCompleted,
  });
}

class LeaderboardService extends GetxService {
  static const _tag = 'LeaderboardService';

  final RxList<LeaderboardEntry> globalLeaderboard = <LeaderboardEntry>[].obs;
  final RxInt playerRank = 0.obs;

  @override
  void onInit() {
    super.onInit();
    AppLogger.info(_tag, 'LeaderboardService stub initialized (future feature)');
  }

  Future<void> fetchLeaderboard() async {
    AppLogger.info(_tag, 'fetchLeaderboard() — not yet implemented');
  }

  Future<void> submitScore(int xp, int levelsCompleted) async {
    AppLogger.info(
        _tag, 'submitScore(xp=$xp, levels=$levelsCompleted) — not yet implemented');
  }
}
