/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    ResultScreen shows win or death feedback after each level.
                Displays the decoded message, reward summary (on success),
                or death animation + story (on failure), with navigation
                options: retry, next level, or home.

---------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cipher_escape/core/constants/colors.dart';
import 'package:cipher_escape/core/constants/dimensions.dart';
import 'package:cipher_escape/core/theme/text_styles.dart';
import 'package:cipher_escape/features/result/result_controller.dart';
import 'package:cipher_escape/models/reward_model.dart';
import 'package:cipher_escape/widgets/gaming_background.dart';
import 'package:cipher_escape/widgets/primary_button.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _fadeIn;
  late Animation<double> _scaleIn;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeIn),
    );
    _scaleIn = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _anim, curve: Curves.elasticOut),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _anim.forward());
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ResultController());

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            GamingBackground(
              overlayColor: ctrl.success ? AppColors.success : AppColors.danger,
              child: const SizedBox.expand(),
            ),
            FadeTransition(
              opacity: _fadeIn,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: ctrl.success
                      ? _SuccessContent(ctrl: ctrl, scaleAnim: _scaleIn)
                      : _DeathContent(ctrl: ctrl, scaleAnim: _scaleIn),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Success content ───────────────────────────────────────────────────────────

class _SuccessContent extends StatelessWidget {
  final ResultController ctrl;
  final Animation<double> scaleAnim;

  const _SuccessContent({required this.ctrl, required this.scaleAnim});

  @override
  Widget build(BuildContext context) {
    final level = ctrl.currentLevel;
    final reward = ctrl.reward;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppDimensions.paddingXL),

        // Success icon with glow
        ScaleTransition(
          scale: scaleAnim,
          child: Text(
            '🔓',
            style: TextStyle(
              fontSize: 88,
              shadows: [
                Shadow(color: AppColors.success.withValues(alpha: 0.6), blurRadius: 30),
                Shadow(color: AppColors.success.withValues(alpha: 0.3), blurRadius: 60),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppDimensions.paddingL),

        Text(
          'ESCAPED',
          style: AppTextStyles.gameTitle.copyWith(
            color: AppColors.success,
            fontSize: 38,
            shadows: [
              Shadow(color: AppColors.success.withValues(alpha: 0.8), blurRadius: 24),
              Shadow(color: AppColors.success.withValues(alpha: 0.4), blurRadius: 48),
            ],
          ),
        ),

        const SizedBox(height: AppDimensions.paddingM),

        if (level != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingS),
            child: Text(
              level.successMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.storyText.copyWith(color: AppColors.textSecondary),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),

        const SizedBox(height: AppDimensions.paddingXL),

        // Rewards
        if (reward != null) _RewardCard(reward: reward, hintsUsed: ctrl.hintsUsed),

        const SizedBox(height: AppDimensions.paddingXL),

        // Actions
        if (ctrl.nextLevel != null)
          PrimaryButton(
            label: '▶  NEXT LEVEL — ${ctrl.nextLevel!.title.toUpperCase()}',
            onTap: ctrl.goToNextLevel,
            color: AppColors.success,
            borderColor: AppColors.success,
          )
        else
          PrimaryButton(
            label: '🏆  YOU COMPLETED ALL LEVELS!',
            onTap: ctrl.goToHome,
            color: AppColors.accentGold,
          ),

        const SizedBox(height: AppDimensions.paddingM),

        PrimaryButton(
          label: '⌂  HOME',
          onTap: ctrl.goToHome,
          color: AppColors.backgroundCard,
          borderColor: AppColors.borderColor,
          textColor: AppColors.textSecondary,
        ),

        const SizedBox(height: AppDimensions.paddingM),
      ],
    );
  }
}

class _RewardCard extends StatelessWidget {
  final RewardModel reward;
  final int hintsUsed;
  const _RewardCard({required this.reward, required this.hintsUsed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient(AppColors.success),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          ...AppColors.glowShadow(AppColors.success, blur: 12, spread: 0),
        ],
      ),
      child: Column(
        children: [
          Text(
            'REWARDS',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: AppDimensions.fontS,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _RewardItem('🪙', '+${reward.totalCoins}', 'COINS'),
              _RewardItem('⚡', '+${reward.xp}', 'XP'),
              _RewardItem('💡', hintsUsed == 0 ? 'NONE' : '$hintsUsed', 'HINTS'),
            ],
          ),
          if (hintsUsed == 0) ...[
            const SizedBox(height: AppDimensions.paddingS),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
                vertical: AppDimensions.paddingXS,
              ),
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
              ),
              child: Text(
                '🧠 No Hints Bonus! +${15} coins',
                style: TextStyle(
                  color: AppColors.accentCyan,
                  fontSize: AppDimensions.fontS,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RewardItem extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  const _RewardItem(this.icon, this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 28)),
        Text(value,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: AppDimensions.fontXL,
                fontWeight: FontWeight.bold)),
        Text(label, style: AppTextStyles.statLabel),
      ],
    );
  }
}

// ── Death content ─────────────────────────────────────────────────────────────

class _DeathContent extends StatelessWidget {
  final ResultController ctrl;
  final Animation<double> scaleAnim;

  const _DeathContent({required this.ctrl, required this.scaleAnim});

  @override
  Widget build(BuildContext context) {
    final level = ctrl.currentLevel;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppDimensions.paddingXL),

        ScaleTransition(
          scale: scaleAnim,
          child: Text(
            '💀',
            style: TextStyle(
              fontSize: 88,
              shadows: [
                Shadow(color: AppColors.danger.withValues(alpha: 0.5), blurRadius: 28),
                Shadow(color: AppColors.danger.withValues(alpha: 0.25), blurRadius: 56),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppDimensions.paddingL),

        Text(
          'YOU DIED',
          style: AppTextStyles.gameTitle.copyWith(
            color: AppColors.danger,
            fontSize: 38,
            shadows: [
              Shadow(color: AppColors.danger.withValues(alpha: 0.8), blurRadius: 24),
              Shadow(color: AppColors.danger.withValues(alpha: 0.4), blurRadius: 48),
            ],
          ),
        ),

        const SizedBox(height: AppDimensions.paddingL),

        // Narrative: what you chose, then what happened
        if (ctrl.wrongChoiceText != null && ctrl.wrongChoiceText!.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: AppColors.backgroundCard.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(color: AppColors.danger.withValues(alpha: 0.4)),
            ),
            child: Text(
              'You chose: "${ctrl.wrongChoiceText}"',
              textAlign: TextAlign.center,
              style: AppTextStyles.storyText.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
        ],
        if (level != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
            ),
            child: Text(
              level.deathMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.storyText.copyWith(height: 1.6),
              maxLines: 6,
              overflow: TextOverflow.fade,
            ),
          ),

        const SizedBox(height: AppDimensions.paddingL),

        // Lives remaining
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Lives remaining: ',
              style: TextStyle(color: AppColors.textSecondary, fontSize: AppDimensions.fontM),
            ),
            ...List.generate(
              3,
              (i) => Text(
                i < ctrl.lives ? '❤️' : '🖤',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.paddingXL),

        Obx(() {
          final hasLives = ctrl.hasLives;
          if (hasLives) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PrimaryButton(
                  label: '🔄  TRY AGAIN',
                  onTap: ctrl.retryLevel,
                  color: AppColors.danger,
                  borderColor: AppColors.danger,
                ),
                const SizedBox(height: AppDimensions.paddingM),
              ],
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'No lives left. Watch a short ad to get 1 life and keep going—lives can\'t be bought with coins.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: AppDimensions.fontM),
                  maxLines: 4,
                  overflow: TextOverflow.fade,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              Obx(() => PrimaryButton(
                    label: ctrl.isLoadingAd.value ? 'Loading ad...' : '▶  WATCH AD FOR 1 LIFE',
                    onTap: ctrl.isLoadingAd.value ? null : ctrl.watchAdForLife,
                    color: AppColors.accentCyan,
                    borderColor: AppColors.accentCyan,
                  )),
              const SizedBox(height: AppDimensions.paddingS),
              Text(
                'Then tap Try again above',
                style: TextStyle(color: AppColors.textMuted, fontSize: AppDimensions.fontS),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              PrimaryButton(
                label: '🛒  STORE (hints & coins)',
                onTap: ctrl.goToStore,
                color: AppColors.backgroundCard,
                borderColor: AppColors.borderColor,
                textColor: AppColors.textSecondary,
              ),
              const SizedBox(height: AppDimensions.paddingM),
            ],
          );
        }),

        PrimaryButton(
          label: '⌂  HOME',
          onTap: ctrl.goToHome,
          color: AppColors.backgroundCard,
          borderColor: AppColors.borderColor,
          textColor: AppColors.textSecondary,
        ),

        const SizedBox(height: AppDimensions.paddingM),
      ],
    );
  }
}
