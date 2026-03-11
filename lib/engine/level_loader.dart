/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    LevelLoader is responsible for loading and parsing level
                data from JSON asset files into LevelModel instances.

---------------------------------------------------
*/

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cipher_escape/core/constants/game_constants.dart';
import 'package:cipher_escape/core/utils/logger.dart';
import 'package:cipher_escape/models/level_model.dart';

class LevelLoader extends GetxService {
  static const _tag = 'LevelLoader';

  final RxBool isLoading = false.obs;
  final RxList<LevelModel> allLevels = <LevelModel>[].obs;

  Future<LevelLoader> init() async {
    await loadAllLevels();
    return this;
  }

  Future<void> loadAllLevels() async {
    isLoading.value = true;
    try {
      final easy = await _loadFile(GameConstants.levelsEasyPath);
      final medium = await _loadFile(GameConstants.levelsMediumPath);
      final hard = await _loadFile(GameConstants.levelsHardPath);
      allLevels.assignAll([...easy, ...medium, ...hard]);
      AppLogger.info(_tag, 'Loaded ${allLevels.length} levels total');
    } catch (e) {
      AppLogger.error(_tag, 'Failed to load levels', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<LevelModel>> _loadFile(String path) async {
    try {
      final jsonString = await rootBundle.loadString(path);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> levelList = jsonData['levels'] as List<dynamic>;
      return levelList
          .map((e) => LevelModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      AppLogger.error(_tag, 'Error loading $path', e);
      return [];
    }
  }

  LevelModel? getLevelById(int id) {
    try {
      return allLevels.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  List<LevelModel> getLevelsByDifficulty(String difficulty) =>
      allLevels.where((l) => l.difficulty == difficulty).toList();

  LevelModel? getNextLevel(int currentId) {
    final next = currentId + 1;
    if (next > GameConstants.totalLevels) return null;
    return getLevelById(next);
  }
}
