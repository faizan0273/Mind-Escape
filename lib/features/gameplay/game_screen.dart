/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    GameScreen is the core gameplay view. It displays the
                level story, encrypted message, hint system, and the
                three action choices for the player to select.

---------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cipher_escape/core/constants/colors.dart';
import 'package:cipher_escape/core/constants/dimensions.dart';
import 'package:cipher_escape/core/theme/text_styles.dart';
import 'package:cipher_escape/core/utils/extensions.dart';
import 'package:cipher_escape/core/utils/helpers.dart';
import 'package:cipher_escape/engine/game_state_manager.dart';
import 'package:cipher_escape/models/level_model.dart';
import 'package:cipher_escape/features/gameplay/game_controller.dart';
import 'package:cipher_escape/core/constants/game_constants.dart';
import 'package:cipher_escape/features/gameplay/widgets/action_buttons.dart';
import 'package:cipher_escape/features/gameplay/widgets/cipher_display.dart';
import 'package:cipher_escape/features/gameplay/widgets/hint_button.dart';
import 'package:cipher_escape/features/gameplay/widgets/scene_intro.dart';
import 'package:cipher_escape/features/hints/hint_system.dart';
import 'package:cipher_escape/widgets/gaming_background.dart';
import 'package:cipher_escape/widgets/loading_widget.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(GameController());
    final state = Get.find<GameStateManager>();

    // When navigating to this screen (e.g. "Next Level" from result), reuse the same
    // controller — load the requested level and reset hints/state after this build
    // so we don't trigger setState/markNeedsBuild during build.
    final args = Get.arguments as Map<String, dynamic>?;
    final levelId = args?['levelId'] as int? ?? 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctrl.loadLevelIfNeeded(levelId);
    });

    return Scaffold(
      body: SafeArea(
        child: GamingBackground(
          child: Obx(() {
          final level = ctrl.level.value;
          if (level == null) {
            return const LoadingWidget(message: 'LOADING...');
          }

          if (ctrl.showSceneIntro.value) {
            return Column(
              children: [
                _TopBar(ctrl: ctrl, state: state),
                Expanded(
                  child: SceneIntro(
                    story: level.story,
                    chapterNumber: level.phase,
                    chapterTitle: GameConstants.chapterTitleForPhase(level.phase),
                    levelTitle: level.title,
                    onContinue: ctrl.startPuzzle,
                  ),
                ),
              ],
            );
          }

          return Column(
              children: [
                _TopBar(ctrl: ctrl, state: state),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppDimensions.paddingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Chapter & level (comms device header)
                        _ChapterLevelHeader(level: level),
                        const SizedBox(height: AppDimensions.paddingS),
                        _UnlockedCipherTools(state: state),
                        const SizedBox(height: AppDimensions.paddingM),

                        // Cipher display (terminal)
                      Obx(() => CipherDisplay(
                            level: level,
                            showCipherType: ctrl.showCipherType.value,
                          )),

                      const SizedBox(height: AppDimensions.paddingM),

                      // Hint section
                      Obx(() => Row(
                            children: [
                              HintButton(
                                isOpen: ctrl.showHints.value,
                                hintsUsed: ctrl.hintCtrl.hintsUsed.value,
                                onTap: ctrl.toggleHints,
                              ),
                              const SizedBox(width: AppDimensions.paddingS),
                              if (!ctrl.showCipherType.value)
                                GestureDetector(
                                  onTap: ctrl.revealCipherType,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppDimensions.paddingM,
                                      vertical: AppDimensions.paddingS,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.accentCyan.withValues(alpha: 0.1),
                                      border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.4)),
                                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                    ),
                                    child: Text(
                                      '⚙ Cipher Type',
                                      style: TextStyle(
                                        color: AppColors.accentCyan,
                                        fontSize: AppDimensions.fontS,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          )),

                      Obx(() => ctrl.showHints.value
                          ? Padding(
                              padding: const EdgeInsets.only(top: AppDimensions.paddingM),
                              child: HintSystem(ctrl: ctrl.hintCtrl),
                            )
                          : const SizedBox.shrink()),

                      const SizedBox(height: AppDimensions.paddingL),

                      // Divider with label — gaming style
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.transparent, AppColors.accentPurple.withValues(alpha: 0.5)],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
                            child: Text(
                              '◆ CHOOSE YOUR ACTION ◆',
                              style: TextStyle(
                                color: AppColors.accentPurple,
                                fontSize: AppDimensions.fontS,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.0,
                                shadows: [
                                  Shadow(color: AppColors.accentPurple.withValues(alpha: 0.5), blurRadius: 8),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppColors.accentPurple.withValues(alpha: 0.5), Colors.transparent],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppDimensions.paddingM),

                      // Action buttons
                      Obx(() => ActionButtons(
                            choices: level.choices,
                            selectedChoiceId: ctrl.selectedChoiceId?.value == -1
                                ? null
                                : ctrl.selectedChoiceId?.value,
                            revealed: ctrl.isRevealed.value,
                            onChoiceTap: ctrl.submitChoice,
                          )),

                      const SizedBox(height: AppDimensions.paddingXL),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
        ),
      ),
    );
  }
}

class _UnlockedCipherTools extends StatelessWidget {
  final GameStateManager state;

  const _UnlockedCipherTools({required this.state});

  @override
  Widget build(BuildContext context) {
    final tools = state.getUnlockedCipherTools();
    if (tools.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        Text(
          'Tools: ',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: AppDimensions.fontXS,
          ),
        ),
        ...tools.map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.3)),
              ),
              child: Text(
                AppHelpers.cipherTypeName(t).replaceAll(' Code', '').replaceAll(' Cipher', ''),
                style: TextStyle(
                  color: AppColors.accentCyan,
                  fontSize: AppDimensions.fontXS,
                  fontFamily: 'monospace',
                ),
              ),
            )),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  final GameController ctrl;
  final GameStateManager state;

  const _TopBar({required this.ctrl, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderColor)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.close, color: AppColors.textMuted, size: 22),
          ),
          const Spacer(),

          // Lives
          Obx(() => Row(
                children: List.generate(
                  3,
                  (i) => Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      i < state.player.value.lives ? '❤️' : '🖤',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              )),

          const SizedBox(width: AppDimensions.paddingM),

          // Coins
          Obx(() => Row(
                children: [
                  const Text('🪙', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    '${state.player.value.coins}',
                    style: const TextStyle(
                      color: AppColors.accentGold,
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.fontM,
                    ),
                  ),
                ],
              )),

          const SizedBox(width: AppDimensions.paddingM),

          // Timer — every level has a countdown; if it hits zero, player loses a life
          Obx(() {
            if (ctrl.timerSeconds.value <= 0) return const SizedBox.shrink();
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingS,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: ctrl.timerSeconds.value.timerColor().withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                border: Border.all(color: ctrl.timerSeconds.value.timerColor()),
              ),
              child: Text(
                ctrl.timerSeconds.value.asCountdown,
                style: AppTextStyles.timer.copyWith(
                  color: ctrl.timerSeconds.value.timerColor(),
                  fontSize: AppDimensions.fontL,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ChapterLevelHeader extends StatelessWidget {
  final LevelModel level;
  const _ChapterLevelHeader({required this.level});

  @override
  Widget build(BuildContext context) {
    final chapterTitle = GameConstants.chapterTitleForPhase(level.phase);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingS,
                vertical: AppDimensions.paddingXS,
              ),
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.4)),
              ),
              child: Text(
                'CH.${level.phase} — ${chapterTitle.toUpperCase()}',
                style: const TextStyle(
                  color: AppColors.accentCyan,
                  fontSize: AppDimensions.fontXS,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'monospace',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ...[
              const SizedBox(width: AppDimensions.paddingS),
              const Icon(Icons.timer, color: AppColors.warning, size: 18),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Text(
          level.title,
          style: AppTextStyles.levelTitle.copyWith(
            fontSize: AppDimensions.fontL,
            color: AppColors.textSecondary,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
