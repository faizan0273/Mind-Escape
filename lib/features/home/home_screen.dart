/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    HomeScreen is the main menu of Cipher Escape. Displays
                the game title, player stats (coins, XP, lives), main
                action buttons, and the level selection panel.

---------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cipher_escape/core/constants/colors.dart';
import 'package:cipher_escape/core/constants/dimensions.dart';
import 'package:cipher_escape/core/constants/game_constants.dart';
import 'package:cipher_escape/core/services/sound_service.dart';
import 'package:cipher_escape/core/theme/text_styles.dart';
import 'package:cipher_escape/core/utils/extensions.dart';
import 'package:cipher_escape/core/utils/helpers.dart';
import 'package:cipher_escape/engine/game_state_manager.dart';
import 'package:cipher_escape/features/home/home_controller.dart';
import 'package:cipher_escape/features/home/widgets/menu_button.dart';
import 'package:cipher_escape/models/level_model.dart';
import 'package:cipher_escape/widgets/gaming_background.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(HomeController());
    final sound = Get.find<SoundService>();

    return Scaffold(
      body: SafeArea(
        child: GamingBackground(
          child: Obx(() => ctrl.showLevelSelect.value
              ? _LevelSelectPanel(ctrl: ctrl)
              : _MainMenu(ctrl: ctrl, sound: sound)),
        ),
      ),
    );
  }
}

// ── Game title with glow ──────────────────────────────────────────────────────

class _GameTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                'CIPHER',
                style: AppTextStyles.gameTitle.copyWith(
                  color: AppColors.accentCyan.withValues(alpha: 0.35),
                  fontSize: AppDimensions.fontDisplay + 4,
                ),
              ),
              Text(
                'CIPHER',
                style: AppTextStyles.gameTitle.copyWith(
                  color: AppColors.accentCyan,
                  fontSize: AppDimensions.fontDisplay,
                  shadows: [
                    Shadow(color: AppColors.accentCyan.withValues(alpha: 0.8), blurRadius: 20),
                    Shadow(color: AppColors.accentCyan.withValues(alpha: 0.4), blurRadius: 40),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                'ESCAPE',
                style: AppTextStyles.gameTitle.copyWith(
                  color: AppColors.accentPurple.withValues(alpha: 0.35),
                  fontSize: AppDimensions.fontDisplay + 10,
                ),
              ),
              Text(
                'ESCAPE',
                style: AppTextStyles.gameTitle.copyWith(
                  color: AppColors.accentPurple,
                  fontSize: AppDimensions.fontDisplay + 6,
                  shadows: [
                    Shadow(color: AppColors.accentPurple.withValues(alpha: 0.8), blurRadius: 24),
                    Shadow(color: AppColors.accentPurple.withValues(alpha: 0.4), blurRadius: 48),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Main menu ────────────────────────────────────────────────────────────────

class _MainMenu extends StatelessWidget {
  final HomeController ctrl;
  final SoundService sound;

  const _MainMenu({required this.ctrl, required this.sound});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: AppDimensions.paddingL),
          // Top row: spacer + wallet (top right, tap to open wallet page)
          Row(
            children: [
              const Spacer(),
              _WalletChip(ctrl: ctrl, sound: sound),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingS),

          // Title — gaming style with glow
          _GameTitle(),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            '// DECODE. CHOOSE. SURVIVE. //',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: AppDimensions.fontS,
              letterSpacing: 2.5,
              fontFamily: 'monospace',
              shadows: [
                Shadow(color: AppColors.accentCyan.withValues(alpha: 0.3), blurRadius: 8),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.paddingXXL),

          // Player stats bar — Obx lives inside _StatsBar
          _StatsBar(ctrl: ctrl),

          const SizedBox(height: AppDimensions.paddingXL),

          // Reset & Play Again when all levels completed
          Obx(() {
            if (!ctrl.hasCompletedAllLevels) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.paddingM),
              child: MenuButton(
                label: 'RESET & PLAY AGAIN',
                subtitle: 'Clear level progress and play from level 1. Keeps wallet, coins, achievements.',
                icon: Icons.replay_rounded,
                accentColor: AppColors.success,
                onTap: () async {
                  sound.playButtonTap();
                  await ctrl.resetLevelProgress();
                  if (context.mounted) {
                    Get.snackbar('Progress reset', 'Play from level 1 again!');
                  }
                },
              ),
            );
          }),

          // Menu buttons
          MenuButton(
            label: 'CONTINUE',
            subtitle: 'Level ${ctrl.currentLevelId}',
            icon: Icons.play_arrow_rounded,
            accentColor: AppColors.accentCyan,
            onTap: () {
              sound.playButtonTap();
              ctrl.continueGame();
            },
          ),
          const SizedBox(height: AppDimensions.paddingM),
          MenuButton(
            label: 'SELECT LEVEL',
            subtitle: '${GameConstants.totalLevels} levels across 3 phases',
            icon: Icons.grid_view_rounded,
            accentColor: AppColors.accentPurple,
            onTap: () {
              sound.playButtonTap();
              ctrl.toggleLevelSelect();
            },
          ),
          const SizedBox(height: AppDimensions.paddingM),
          MenuButton(
            label: 'STORE',
            subtitle: 'Hints for coins, lives by watching ads',
            icon: Icons.storefront_rounded,
            accentColor: AppColors.accentGold,
            onTap: () {
              sound.playButtonTap();
              ctrl.goToStore();
            },
          ),
          const SizedBox(height: AppDimensions.paddingM),
          MenuButton(
            label: 'ACHIEVEMENTS',
            subtitle: 'Track your progress',
            icon: Icons.emoji_events_rounded,
            accentColor: AppColors.accentCyan,
            onTap: () {
              sound.playButtonTap();
              ctrl.goToAchievements();
            },
          ),
          Obx(() {
            final state = Get.find<GameStateManager>();
            if (!state.isArchiveUnlocked) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.paddingM),
              child: MenuButton(
                label: 'ARCHIVE',
                subtitle: 'Secret story files · ${state.endingsCount}/${GameConstants.totalEndings} endings',
                icon: Icons.folder_special_rounded,
                accentColor: AppColors.senderUnknown,
                onTap: () {
                  sound.playButtonTap();
                  ctrl.goToArchive();
                },
              ),
            );
          }),
          const SizedBox(height: AppDimensions.paddingM),
          _StreakAndDailyRow(),
          const SizedBox(height: AppDimensions.paddingM),
          const SizedBox(height: AppDimensions.paddingM),

          // Sound toggles row — Obx lives inside _SettingsRow
          _SettingsRow(sound: sound),

          const SizedBox(height: AppDimensions.paddingXL),

          // Phase indicators
          _PhaseIndicator(ctrl: ctrl),

          const SizedBox(height: AppDimensions.paddingL),
        ],
      ),
    );
  }
}

/// Compact wallet display for top-right corner. Shows only price; tap opens wallet page.
class _WalletChip extends StatelessWidget {
  final HomeController ctrl;
  final SoundService sound;

  const _WalletChip({required this.ctrl, required this.sound});

  @override
  Widget build(BuildContext context) {
    final state = Get.find<GameStateManager>();
    return Obx(() {
      final cents = state.walletBalanceCents.value;
      final balanceStr = '\$${(cents / 100).toStringAsFixed(2)}';
      return GestureDetector(
        onTap: () {
          sound.playButtonTap();
          ctrl.goToWallet();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingS,
          ),
          decoration: BoxDecoration(
            color: AppColors.accentGold.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('💰', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text(
                balanceStr,
                style: const TextStyle(
                  color: AppColors.accentGold,
                  fontSize: AppDimensions.fontL,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _StreakAndDailyRow extends StatelessWidget {
  const _StreakAndDailyRow();

  @override
  Widget build(BuildContext context) {
    final state = Get.find<GameStateManager>();
    return Obx(() {
      final streak = state.streak;
      return Row(
        children: [
          if (streak > 0)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                  vertical: AppDimensions.paddingS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(color: AppColors.accentOrange.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🔥', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    Text(
                      '$streak streak',
                      style: TextStyle(
                        color: AppColors.accentOrange,
                        fontSize: AppDimensions.fontS,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (streak > 0) const SizedBox(width: AppDimensions.paddingM),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.snackbar(
                  'Daily Puzzle',
                  'Coming in a future update: one new puzzle per day + optional reminder notifications.',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 3),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                  vertical: AppDimensions.paddingS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentCyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.4)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.today_rounded, color: AppColors.accentCyan, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          'Daily Puzzle',
                          style: TextStyle(
                            color: AppColors.accentCyan,
                            fontSize: AppDimensions.fontS,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Coming in a future update',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _StatsBar extends StatelessWidget {
  final HomeController ctrl;
  const _StatsBar({required this.ctrl});

  Widget _divider() => Container(width: 1, height: 36, color: AppColors.borderColor);

  @override
  Widget build(BuildContext context) {
    // Obx here directly reads GameStateManager.player (Rx<PlayerModel>)
    // so GetX correctly tracks updates.
    final state = Get.find<GameStateManager>();
    return Obx(() {
      final p = state.player.value;
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingL,
          vertical: AppDimensions.paddingM,
        ),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient(AppColors.accentCyan),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: AppColors.accentCyan.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            ...AppColors.glowShadow(AppColors.accentCyan, blur: 12, spread: 0),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(icon: '🪙', value: '${p.coins}', label: 'COINS'),
            _divider(),
            _StatItem(icon: '⚡', value: '${p.xp}', label: 'XP'),
            _divider(),
            _StatItem(
              icon: '❤️',
              value: List.generate(3, (i) => i < p.lives ? '❤️' : '🖤').join(),
              label: 'LIVES',
            ),
          ],
        ),
      );
    });
  }
}

class _StatItem extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _StatItem({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$icon $value',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppDimensions.fontL,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.statLabel, maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final SoundService sound;
  const _SettingsRow({required this.sound});

  @override
  Widget build(BuildContext context) {
    // Obx here directly reads sound.isSoundOn and sound.isMusicOn (RxBool)
    // so GetX correctly tracks toggles.
    return Obx(() => Wrap(
          alignment: WrapAlignment.center,
          spacing: AppDimensions.paddingM,
          runSpacing: AppDimensions.paddingS,
          children: [
            _ToggleChip(
              label: sound.isSoundOn.value ? '🔊 SFX ON' : '🔇 SFX OFF',
              active: sound.isSoundOn.value,
              onTap: sound.toggleSound,
            ),
            _ToggleChip(
              label: sound.isMusicOn.value ? '🎵 MUSIC ON' : '🔕 MUSIC OFF',
              active: sound.isMusicOn.value,
              onTap: sound.toggleMusic,
            ),
          ],
        ));
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _ToggleChip({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.accentCyan.withValues(alpha: 0.1) : AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
          border: Border.all(
            color: active ? AppColors.accentCyan.withValues(alpha: 0.5) : AppColors.borderColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? AppColors.accentCyan : AppColors.textMuted,
            fontSize: AppDimensions.fontS,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _PhaseIndicator extends StatelessWidget {
  final HomeController ctrl;
  const _PhaseIndicator({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final phases = [
      {'phase': 'Phase 1', 'name': 'THE NEXUS', 'range': '1–10', 'color': AppColors.difficultyEasy, 'difficulty': GameConstants.difficultyEasy},
      {'phase': 'Phase 2', 'name': 'THE ARCHIVE', 'range': '11–20', 'color': AppColors.difficultyMedium, 'difficulty': GameConstants.difficultyMedium},
      {'phase': 'Phase 3', 'name': 'THE OVERSEER', 'range': '21–30', 'color': AppColors.difficultyHard, 'difficulty': GameConstants.difficultyHard},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'STORY PHASES',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: AppDimensions.fontS,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tap a phase to open its levels',
          style: TextStyle(
            color: AppColors.textMuted.withValues(alpha: 0.8),
            fontSize: AppDimensions.fontXS,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingS),
        Row(
          children: phases.map((p) {
            final color = p['color'] as Color;
            final difficulty = p['difficulty'] as String;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  if (!ctrl.showLevelSelect.value) {
                    ctrl.toggleLevelSelect();
                  }
                  ctrl.selectDifficulty(difficulty);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: AppDimensions.paddingS),
                  padding: const EdgeInsets.all(AppDimensions.paddingM),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.withValues(alpha: 0.15),
                        color.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
                    boxShadow: [
                      BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 8),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        p['phase'] as String,
                        style: TextStyle(
                          color: color,
                          fontSize: AppDimensions.fontXS,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p['name'] as String,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: AppDimensions.fontS,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Lv ${p['range']}',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: AppDimensions.fontXS,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── Level select panel ────────────────────────────────────────────────────────

class _LevelSelectPanel extends StatelessWidget {
  final HomeController ctrl;
  const _LevelSelectPanel({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Row(
            children: [
              GestureDetector(
                onTap: ctrl.toggleLevelSelect,
                child: const Icon(Icons.arrow_back, color: AppColors.accentCyan),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              const Text(
                'SELECT LEVEL',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppDimensions.fontXL,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        ),

        // Difficulty tabs — Obx lives inside _DifficultyTabs
        _DifficultyTabs(ctrl: ctrl),

        const SizedBox(height: AppDimensions.paddingM),

        // Level grid — responsive column count
        Expanded(
          child: Obx(() {
            final levels = ctrl.displayedLevels;
            final crossCount = context.screenWidth > 400 ? 5 : (context.screenWidth > 320 ? 4 : 3);
            return GridView.builder(
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossCount,
                crossAxisSpacing: AppDimensions.paddingS,
                mainAxisSpacing: AppDimensions.paddingS,
                childAspectRatio: 0.85,
              ),
              itemCount: levels.length,
              itemBuilder: (_, i) {
                final level = levels[i];
                return _LevelCell(level: level, ctrl: ctrl);
              },
            );
          }),
        ),
      ],
    );
  }
}

class _DifficultyTabs extends StatelessWidget {
  final HomeController ctrl;
  const _DifficultyTabs({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    const tabs = [
      (GameConstants.difficultyEasy, 'EASY', AppColors.difficultyEasy),
      (GameConstants.difficultyMedium, 'MED', AppColors.difficultyMedium),
      (GameConstants.difficultyHard, 'HARD', AppColors.difficultyHard),
    ];

    // Obx here directly reads ctrl.selectedDifficulty (RxString)
    // so GetX correctly re-renders when the selected tab changes.
    return Obx(() {
      final selected = ctrl.selectedDifficulty.value;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
        child: Row(
          children: tabs.map((t) {
            final isSelected = selected == t.$1;
            return Expanded(
              child: GestureDetector(
                onTap: () => ctrl.selectDifficulty(t.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: AppDimensions.animFast),
                  margin: const EdgeInsets.only(right: AppDimensions.paddingS),
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
                  decoration: BoxDecoration(
                    color: isSelected ? t.$3.withValues(alpha: 0.15) : AppColors.backgroundCard,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    border: Border.all(
                      color: isSelected ? t.$3 : AppColors.borderColor,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      t.$2,
                      style: TextStyle(
                        color: isSelected ? t.$3 : AppColors.textMuted,
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimensions.fontS,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}

class _LevelCell extends StatelessWidget {
  final LevelModel level;
  final HomeController ctrl;

  const _LevelCell({required this.level, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final unlocked = ctrl.isLevelUnlocked(level.id);
    final completed = ctrl.isLevelCompleted(level.id);
    final diffColor = AppHelpers.difficultyColor(level.difficulty);

    Color borderCol;
    Color textCol;
    if (completed) {
      borderCol = AppColors.success;
      textCol = AppColors.success;
    } else if (unlocked) {
      borderCol = diffColor;
      textCol = AppColors.textPrimary;
    } else {
      borderCol = AppColors.borderColor;
      textCol = AppColors.textMuted;
    }

    return GestureDetector(
      onTap: unlocked ? () => ctrl.startLevel(level.id) : null,
      child: Container(
        decoration: BoxDecoration(
          color: completed
              ? AppColors.success.withValues(alpha: 0.1)
              : AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          border: Border.all(color: borderCol, width: 1.5),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                completed ? '✓' : (unlocked ? '${level.id}' : '🔒'),
                style: TextStyle(
                  color: textCol,
                  fontSize: completed || !unlocked
                      ? AppDimensions.fontM
                      : AppDimensions.fontL,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
