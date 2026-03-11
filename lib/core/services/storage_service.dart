/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Persistent storage service wrapping SharedPreferences.
                Handles all local data read/write for player progress,
                settings, and achievements.

---------------------------------------------------
*/

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cipher_escape/core/constants/game_constants.dart';
import 'package:cipher_escape/core/utils/logger.dart';

class StorageService extends GetxService {
  static const _tag = 'StorageService';
  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    AppLogger.info(_tag, 'StorageService initialized');
    return this;
  }

  // ── Player coins ──────────────────────────────────────────────────────────

  int getCoins() => _prefs.getInt(GameConstants.keyPlayerCoins) ?? 100;

  Future<void> saveCoins(int coins) =>
      _prefs.setInt(GameConstants.keyPlayerCoins, coins);

  // ── Player XP ────────────────────────────────────────────────────────────

  int getXp() => _prefs.getInt(GameConstants.keyPlayerXp) ?? 0;

  Future<void> saveXp(int xp) =>
      _prefs.setInt(GameConstants.keyPlayerXp, xp);

  // ── Player lives ─────────────────────────────────────────────────────────

  int getLives() =>
      _prefs.getInt(GameConstants.keyPlayerLives) ?? GameConstants.defaultLives;

  Future<void> saveLives(int lives) =>
      _prefs.setInt(GameConstants.keyPlayerLives, lives);

  // ── Current level ─────────────────────────────────────────────────────────

  int getCurrentLevel() => _prefs.getInt(GameConstants.keyCurrentLevel) ?? 1;

  Future<void> saveCurrentLevel(int level) =>
      _prefs.setInt(GameConstants.keyCurrentLevel, level);

  // ── Completed levels ──────────────────────────────────────────────────────

  List<int> getCompletedLevels() {
    final raw = _prefs.getStringList(GameConstants.keyCompletedLevels) ?? [];
    return raw.map(int.parse).toList();
  }

  Future<void> addCompletedLevel(int levelId) async {
    final completed = getCompletedLevels();
    if (!completed.contains(levelId)) {
      completed.add(levelId);
      await _prefs.setStringList(
        GameConstants.keyCompletedLevels,
        completed.map((e) => e.toString()).toList(),
      );
    }
  }

  Future<void> setCompletedLevels(List<int> levelIds) async {
    await _prefs.setStringList(
      GameConstants.keyCompletedLevels,
      levelIds.map((e) => e.toString()).toList(),
    );
  }

  // ── Achievements ──────────────────────────────────────────────────────────

  List<String> getAchievements() =>
      _prefs.getStringList(GameConstants.keyAchievements) ?? [];

  Future<void> addAchievement(String id) async {
    final list = getAchievements();
    if (!list.contains(id)) {
      list.add(id);
      await _prefs.setStringList(GameConstants.keyAchievements, list);
      AppLogger.info(_tag, 'Achievement unlocked: $id');
    }
  }

  bool hasAchievement(String id) => getAchievements().contains(id);

  // ── Mystery hook & archive ───────────────────────────────────────────────

  bool getMysteryHookSeen() =>
      _prefs.getBool(GameConstants.keyMysteryHookSeen) ?? false;
  Future<void> setMysteryHookSeen(bool value) =>
      _prefs.setBool(GameConstants.keyMysteryHookSeen, value);

  bool getArchiveUnlocked() =>
      _prefs.getBool(GameConstants.keyArchiveUnlocked) ?? false;
  Future<void> setArchiveUnlocked(bool value) =>
      _prefs.setBool(GameConstants.keyArchiveUnlocked, value);

  List<String> getStoryFilesUnlocked() =>
      _prefs.getStringList(GameConstants.keyStoryFilesUnlocked) ?? [];
  Future<void> setStoryFilesUnlocked(List<String> ids) =>
      _prefs.setStringList(GameConstants.keyStoryFilesUnlocked, ids);

  int getEndingsDiscovered() =>
      _prefs.getInt(GameConstants.keyEndingsDiscovered) ?? 0;
  Future<void> setEndingsDiscovered(int count) =>
      _prefs.setInt(GameConstants.keyEndingsDiscovered, count);

  int getCurrentStreak() =>
      _prefs.getInt(GameConstants.keyCurrentStreak) ?? 0;
  Future<void> setCurrentStreak(int value) =>
      _prefs.setInt(GameConstants.keyCurrentStreak, value);

  int getLastCompletedLevelId() =>
      _prefs.getInt(GameConstants.keyLastCompletedLevelId) ?? 0;
  Future<void> setLastCompletedLevelId(int id) =>
      _prefs.setInt(GameConstants.keyLastCompletedLevelId, id);

  String? getDailyPuzzleLastPlayedDate() =>
      _prefs.getString(GameConstants.keyDailyPuzzleLastPlayedDate);
  Future<void> setDailyPuzzleLastPlayedDate(String dateStr) =>
      _prefs.setString(GameConstants.keyDailyPuzzleLastPlayedDate, dateStr);

  // ── Wallet ──────────────────────────────────────────────────────────────

  int getWalletBalanceCents() =>
      _prefs.getInt(GameConstants.keyWalletBalanceCents) ?? 0;
  Future<void> setWalletBalanceCents(int cents) =>
      _prefs.setInt(GameConstants.keyWalletBalanceCents, cents);

  /// Clears level progress only (completed levels + current level). Wallet and other data kept.
  Future<void> clearLevelProgress() async {
    await _prefs.setStringList(GameConstants.keyCompletedLevels, []);
    await _prefs.setInt(GameConstants.keyCurrentLevel, 1);
    AppLogger.info(_tag, 'Level progress cleared');
  }

  // ── Settings ──────────────────────────────────────────────────────────────

  bool isSoundEnabled() => _prefs.getBool(GameConstants.keySoundEnabled) ?? true;
  Future<void> setSoundEnabled(bool value) =>
      _prefs.setBool(GameConstants.keySoundEnabled, value);

  bool isMusicEnabled() => _prefs.getBool(GameConstants.keyMusicEnabled) ?? true;
  Future<void> setMusicEnabled(bool value) =>
      _prefs.setBool(GameConstants.keyMusicEnabled, value);

  // ── Reset ─────────────────────────────────────────────────────────────────

  Future<void> resetProgress() async {
    await _prefs.remove(GameConstants.keyPlayerCoins);
    await _prefs.remove(GameConstants.keyPlayerXp);
    await _prefs.remove(GameConstants.keyPlayerLives);
    await _prefs.remove(GameConstants.keyCurrentLevel);
    await _prefs.remove(GameConstants.keyCompletedLevels);
    await _prefs.remove(GameConstants.keyAchievements);
    await _prefs.remove(GameConstants.keyMysteryHookSeen);
    await _prefs.remove(GameConstants.keyArchiveUnlocked);
    await _prefs.remove(GameConstants.keyStoryFilesUnlocked);
    await _prefs.remove(GameConstants.keyEndingsDiscovered);
    await _prefs.remove(GameConstants.keyCurrentStreak);
    await _prefs.remove(GameConstants.keyLastCompletedLevelId);
    await _prefs.remove(GameConstants.keyDailyPuzzleLastPlayedDate);
    await _prefs.remove(GameConstants.keyWalletBalanceCents);
    AppLogger.info(_tag, 'Progress reset');
  }
}
