/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Repository that provides level data to features/controllers.
                Acts as an abstraction layer over the LevelLoader engine.

---------------------------------------------------
*/

import 'package:get/get.dart';
import 'package:cipher_escape/core/constants/game_constants.dart';
import 'package:cipher_escape/engine/level_loader.dart';
import 'package:cipher_escape/engine/game_state_manager.dart';
import 'package:cipher_escape/models/level_model.dart';

class LevelRepository {
  final LevelLoader _loader = Get.find<LevelLoader>();
  final GameStateManager _state = Get.find<GameStateManager>();

  List<LevelModel> get allLevels => _loader.allLevels;

  List<LevelModel> get easyLevels =>
      _loader.getLevelsByDifficulty(GameConstants.difficultyEasy);

  List<LevelModel> get mediumLevels =>
      _loader.getLevelsByDifficulty(GameConstants.difficultyMedium);

  List<LevelModel> get hardLevels =>
      _loader.getLevelsByDifficulty(GameConstants.difficultyHard);

  LevelModel? getLevelById(int id) => _loader.getLevelById(id);

  LevelModel? getNextLevel(int currentId) => _loader.getNextLevel(currentId);

  bool isCompleted(int levelId) =>
      _state.player.value.isLevelCompleted(levelId);

  bool isUnlocked(int levelId) =>
      _state.player.value.isLevelUnlocked(levelId);

  int get currentLevelId => _state.player.value.currentLevel;

  LevelModel? get currentLevel => getLevelById(currentLevelId);
}
