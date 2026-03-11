/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Sound service for Cipher Escape. Plays story-driven SFX:
                message notification, Morse beeps, door open, failure.
                Add .mp3 files to assets/sounds/effects/ (see .gitkeep there).
---------------------------------------------------
*/

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cipher_escape/core/services/storage_service.dart';
import 'package:cipher_escape/core/utils/logger.dart';

class SoundService extends GetxService {
  static const _tag = 'SoundService';

  final RxBool isSoundOn = true.obs;
  final RxBool isMusicOn = true.obs;

  AudioPlayer? _sfxPlayer;
  bool _pluginFailed = false;

  @override
  void onInit() {
    super.onInit();
    final storage = Get.find<StorageService>();
    isSoundOn.value = storage.isSoundEnabled();
    isMusicOn.value = storage.isMusicEnabled();
    AppLogger.info(_tag, 'SoundService initialized');
  }

  @override
  void onClose() {
    _sfxPlayer?.dispose();
    _sfxPlayer = null;
    super.onClose();
  }

  void toggleSound() {
    isSoundOn.toggle();
    Get.find<StorageService>().setSoundEnabled(isSoundOn.value);
  }

  void toggleMusic() {
    isMusicOn.toggle();
    Get.find<StorageService>().setMusicEnabled(isMusicOn.value);
  }

  Future<void> _playAsset(String filename) async {
    if (!isSoundOn.value || _pluginFailed) return;
    try {
      _sfxPlayer ??= AudioPlayer();
      await _sfxPlayer!.setReleaseMode(ReleaseMode.release);
      await _sfxPlayer!.stop();
      await _sfxPlayer!.play(AssetSource('assets/sounds/effects/$filename'));
    } on MissingPluginException catch (_) {
      _pluginFailed = true;
      AppLogger.warning(_tag, 'audioplayers plugin not registered — run full rebuild (flutter run) to enable sound');
    } catch (_) {
      // Asset missing or load failed — silent no-op
    }
  }

  /// When a new encrypted message arrives (scene continue).
  void playMessageNotification() {
    if (!isSoundOn.value) return;
    _playAsset('message.mp3').catchError((_) {});
  }

  /// Morse code short beep (dot).
  void playMorseDot() {
    if (!isSoundOn.value) return;
    _playAsset('morse_dot.mp3').catchError((_) {});
  }

  /// Morse code long beep (dash).
  void playMorseDash() {
    if (!isSoundOn.value) return;
    _playAsset('morse_dash.mp3').catchError((_) {});
  }

  /// Correct choice / door opening.
  void playDoorOpen() {
    if (!isSoundOn.value) return;
    _playAsset('door_open.mp3').catchError((_) {});
  }

  /// Wrong choice / death.
  void playFailure() {
    if (!isSoundOn.value) return;
    _playAsset('failure.mp3').catchError((_) {});
  }

  void playCorrect() {
    if (!isSoundOn.value) return;
    _playAsset('door_open.mp3').catchError((_) {});
  }

  void playWrong() {
    playFailure();
  }

  void playButtonTap() {
    if (!isSoundOn.value) return;
    _playAsset('message.mp3').catchError((_) {});
  }

  void playLevelComplete() => playDoorOpen();

  void playDeath() => playFailure();

  void playHint() {
    if (!isSoundOn.value) return;
    _playAsset('message.mp3').catchError((_) {});
  }

  void startBackgroundMusic() {
    if (!isMusicOn.value) return;
  }

  void stopBackgroundMusic() {}
}
