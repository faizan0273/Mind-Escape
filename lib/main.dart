/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    App entry point for Cipher Escape. Initializes all
                services (storage, sound, ads, analytics), loads level
                data, and sets up GetX routing across all screens.

---------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cipher_escape/core/constants/game_constants.dart';
import 'package:cipher_escape/core/services/ad_service.dart';
import 'package:cipher_escape/core/services/analytics_service.dart';
import 'package:cipher_escape/core/services/sound_service.dart';
import 'package:cipher_escape/core/services/storage_service.dart';
import 'package:cipher_escape/core/theme/app_theme.dart';
import 'package:cipher_escape/engine/event_bus.dart';
import 'package:cipher_escape/engine/game_engine.dart';
import 'package:cipher_escape/engine/game_state_manager.dart';
import 'package:cipher_escape/engine/level_loader.dart';
import 'package:cipher_escape/features/achievements/achievements_screen.dart';
import 'package:cipher_escape/features/archive/archive_screen.dart';
import 'package:cipher_escape/features/gameplay/game_screen.dart';
import 'package:cipher_escape/features/home/home_screen.dart';
import 'package:cipher_escape/features/mystery/mystery_hook_screen.dart';
import 'package:cipher_escape/features/result/result_screen.dart';
import 'package:cipher_escape/features/store/store_screen.dart';
import 'package:cipher_escape/features/wallet/wallet_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // System UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // Initialize core services
  await Get.putAsync(() => StorageService().init());
  Get.put(EventBus());
  Get.put(AnalyticsService());
  Get.put(AdService());
  Get.put(SoundService());
  Get.put(GameStateManager());
  await Get.putAsync(() => LevelLoader().init());
  Get.put(GameEngine());

  runApp(const CipherEscapeApp());
}

class CipherEscapeApp extends StatelessWidget {
  const CipherEscapeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cipher Escape',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialRoute: GameConstants.routeHome,
      getPages: [
        GetPage(
          name: GameConstants.routeHome,
          page: () => const HomeScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: GameConstants.routeGame,
          page: () => const GameScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: GameConstants.routeResult,
          page: () => const ResultScreen(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 400),
        ),
        GetPage(
          name: GameConstants.routeStore,
          page: () => const StoreScreen(),
          transition: Transition.downToUp,
        ),
        GetPage(
          name: GameConstants.routeAchievements,
          page: () => const AchievementsScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: GameConstants.routeMysteryHook,
          page: () => const MysteryHookScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: GameConstants.routeArchive,
          page: () => const ArchiveScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: GameConstants.routeWallet,
          page: () => const WalletScreen(),
          transition: Transition.fadeIn,
        ),
      ],
    );
  }
}
