/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Manages the global game state including player data,
                loading/saving progress, and dispatching state events.

---------------------------------------------------
*/

import 'package:get/get.dart';
import 'package:cipher_escape/core/constants/game_constants.dart';
import 'package:cipher_escape/core/services/storage_service.dart';
import 'package:cipher_escape/core/utils/logger.dart';
import 'package:cipher_escape/engine/event_bus.dart';
import 'package:cipher_escape/models/player_model.dart';

class GameStateManager extends GetxService {
  static const _tag = 'GameStateManager';

  late final StorageService _storage;
  late final EventBus _bus;

  final Rx<PlayerModel> player = PlayerModel.initial().obs;

  final RxBool mysteryHookSeen = false.obs;
  final RxBool archiveUnlocked = false.obs;
  final RxList<String> storyFilesUnlocked = <String>[].obs;
  final RxInt endingsDiscovered = 0.obs;
  final RxInt currentStreak = 0.obs;
  final RxInt walletBalanceCents = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _storage = Get.find<StorageService>();
    _bus = Get.find<EventBus>();
    _loadPlayer();
    _loadMysteryState();
    _loadWallet();
    AppLogger.info(_tag, 'GameStateManager initialized');
  }

  void _loadWallet() {
    walletBalanceCents.value = _storage.getWalletBalanceCents();
  }

  void _loadPlayer() {
    player.value = PlayerModel(
      coins: _storage.getCoins(),
      xp: _storage.getXp(),
      lives: _storage.getLives(),
      currentLevel: _storage.getCurrentLevel(),
      completedLevels: _storage.getCompletedLevels(),
      achievements: _storage.getAchievements(),
    );
    AppLogger.info(_tag, 'Player loaded: coins=${player.value.coins}, level=${player.value.currentLevel}');
  }

  void _loadMysteryState() {
    mysteryHookSeen.value = _storage.getMysteryHookSeen();
    archiveUnlocked.value = _storage.getArchiveUnlocked();
    storyFilesUnlocked.assignAll(_storage.getStoryFilesUnlocked());
    endingsDiscovered.value = _storage.getEndingsDiscovered();
    currentStreak.value = _storage.getCurrentStreak();
  }

  // ── Coins ─────────────────────────────────────────────────────────────────

  Future<void> addCoins(int amount) async {
    player.update((p) => p!.coins += amount);
    await _storage.saveCoins(player.value.coins);
    _bus.emit(GameEvent.coinsUpdated, {'coins': player.value.coins});
  }

  Future<bool> spendCoins(int amount) async {
    if (player.value.coins < amount) return false;
    player.update((p) => p!.coins -= amount);
    await _storage.saveCoins(player.value.coins);
    _bus.emit(GameEvent.coinsUpdated, {'coins': player.value.coins});
    return true;
  }

  // ── XP ────────────────────────────────────────────────────────────────────

  Future<void> addXp(int amount) async {
    player.update((p) => p!.xp += amount);
    await _storage.saveXp(player.value.xp);
    _bus.emit(GameEvent.xpUpdated, {'xp': player.value.xp});
  }

  // ── Lives ─────────────────────────────────────────────────────────────────

  Future<void> loseLife() async {
    if (player.value.lives > 0) {
      player.update((p) => p!.lives--);
      await _storage.saveLives(player.value.lives);
      _bus.emit(GameEvent.playerDied, {'lives': player.value.lives});
    }
  }

  Future<void> restoreLives([int count = 1]) async {
    final newLives = (player.value.lives + count).clamp(0, GameConstants.defaultLives);
    player.update((p) => p!.lives = newLives);
    await _storage.saveLives(newLives);
    _bus.emit(GameEvent.livesRestored, {'lives': newLives});
  }

  bool get hasLives => player.value.lives > 0;

  // ── Level progress ────────────────────────────────────────────────────────

  Future<void> completeLevel(int levelId) async {
    player.update((p) {
      if (!p!.completedLevels.contains(levelId)) {
        p.completedLevels.add(levelId);
      }
      if (levelId >= p.currentLevel) {
        p.currentLevel = levelId + 1;
      }
    });
    await _storage.addCompletedLevel(levelId);
    await _storage.saveCurrentLevel(player.value.currentLevel);
    _bus.emit(GameEvent.levelCompleted, {'levelId': levelId});
    AppLogger.info(_tag, 'Level $levelId completed');
  }

  /// Whether the player has completed all levels (e.g. 30/30).
  bool get hasCompletedAllLevels {
    final completed = player.value.completedLevels;
    return completed.length >= GameConstants.totalLevels;
  }

  /// Wallet: add cents (e.g. 500 = $5). Persisted.
  Future<void> addToWallet(int cents) async {
    if (cents <= 0) return;
    walletBalanceCents.value += cents;
    await _storage.setWalletBalanceCents(walletBalanceCents.value);
    AppLogger.info(_tag, 'Wallet +${cents}¢ → \$${(walletBalanceCents.value / 100).toStringAsFixed(2)}');
  }

  /// Wallet: can withdraw when balance >= $50.
  bool get canWithdraw =>
      walletBalanceCents.value >= GameConstants.walletWithdrawThresholdCents;

  /// Reset only level progress so the player can play through again. Keeps wallet, coins, lives, achievements.
  Future<void> resetLevelProgress() async {
    await _storage.clearLevelProgress();
    player.update((p) {
      if (p != null) {
        p.completedLevels.clear();
        p.currentLevel = 1;
      }
    });
    _bus.emit(GameEvent.levelCompleted, {'levelId': 0}); // signal refresh
    AppLogger.info(_tag, 'Level progress reset — play again from level 1');
  }

  // ── Achievements ──────────────────────────────────────────────────────────

  Future<void> unlockAchievement(String id) async {
    if (player.value.hasAchievement(id)) return;
    player.update((p) => p!.achievements.add(id));
    await _storage.addAchievement(id);
    _bus.emit(GameEvent.achievementUnlocked, {'achievementId': id});
    AppLogger.info(_tag, 'Achievement unlocked: $id');
  }

  // ── Mystery & archive ─────────────────────────────────────────────────────

  bool get hasSeenMysteryHook => mysteryHookSeen.value;
  bool get isArchiveUnlocked => archiveUnlocked.value;
  int get endingsCount => endingsDiscovered.value;
  int get streak => currentStreak.value;

  Future<void> markMysteryHookSeenAndUnlockArchive() async {
    mysteryHookSeen.value = true;
    archiveUnlocked.value = true;
    await _storage.setMysteryHookSeen(true);
    await _storage.setArchiveUnlocked(true);
    AppLogger.info(_tag, 'Mystery hook seen, archive unlocked');
  }

  bool isStoryFileUnlocked(String id) => storyFilesUnlocked.contains(id);
  Future<void> unlockStoryFile(String id) async {
    if (storyFilesUnlocked.contains(id)) return;
    storyFilesUnlocked.add(id);
    await _storage.setStoryFilesUnlocked(storyFilesUnlocked.toList());
    endingsDiscovered.value = storyFilesUnlocked.length;
    await _storage.setEndingsDiscovered(endingsDiscovered.value);
  }

  Future<void> updateStreakAfterSuccess(int completedLevelId) async {
    final last = _storage.getLastCompletedLevelId();
    final newStreak = (completedLevelId == last + 1) ? currentStreak.value + 1 : 1;
    currentStreak.value = newStreak;
    await _storage.setCurrentStreak(newStreak);
    await _storage.setLastCompletedLevelId(completedLevelId);
  }

  Future<void> resetStreak() async {
    currentStreak.value = 0;
    await _storage.setCurrentStreak(0);
  }

  List<String> getUnlockedCipherTools() {
    final maxLevel = player.value.currentLevel - 1;
    return GameConstants.cipherUnlockLevels.entries
        .where((e) => maxLevel >= e.value)
        .map((e) => e.key)
        .toList();
  }

  // ── Reset ─────────────────────────────────────────────────────────────────

  Future<void> resetAll() async {
    await _storage.resetProgress();
    player.value = PlayerModel.initial();
    _loadMysteryState();
    AppLogger.info(_tag, 'All progress reset');
  }
}
