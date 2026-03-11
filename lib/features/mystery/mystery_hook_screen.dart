/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Mystery hook shown once after completing Level 3.
                System glitch animation then secret message from Unknown Sender,
                then unlocks the Archive in the menu.
---------------------------------------------------
*/

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cipher_escape/core/constants/colors.dart';
import 'package:cipher_escape/core/constants/dimensions.dart';
import 'package:cipher_escape/core/constants/game_constants.dart';
import 'package:cipher_escape/engine/game_state_manager.dart';
import 'package:cipher_escape/widgets/gaming_background.dart';

class MysteryHookScreen extends StatefulWidget {
  const MysteryHookScreen({super.key});

  @override
  State<MysteryHookScreen> createState() => _MysteryHookScreenState();
}

class _MysteryHookScreenState extends State<MysteryHookScreen>
    with TickerProviderStateMixin {
  static const _glitchDuration = Duration(milliseconds: 2200);
  static const _messageRevealDuration = Duration(milliseconds: 800);

  late AnimationController _glitchCtrl;
  late Animation<double> _glitchNoise;
  bool _showMessage = false;
  bool _showContinue = false;

  @override
  void initState() {
    super.initState();
    _glitchCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _glitchNoise = Tween<double>(begin: 0, end: 1).animate(_glitchCtrl);
    _runSequence();
  }

  Future<void> _runSequence() async {
    await _runGlitch();
    if (!mounted) return;
    setState(() => _showMessage = true);
    await Future.delayed(_messageRevealDuration);
    if (!mounted) return;
    setState(() => _showContinue = true);
  }

  Future<void> _runGlitch() async {
    final rand = math.Random();
    final end = DateTime.now().add(_glitchDuration);
    while (DateTime.now().isBefore(end) && mounted) {
      _glitchCtrl.forward(from: 0);
      await Future.delayed(Duration(milliseconds: 80 + rand.nextInt(120)));
      if (!mounted) return;
      _glitchCtrl.reset();
      await Future.delayed(Duration(milliseconds: 40 + rand.nextInt(80)));
    }
  }

  @override
  void dispose() {
    _glitchCtrl.dispose();
    super.dispose();
  }

  void _onContinue() async {
    final state = Get.find<GameStateManager>();
    await state.markMysteryHookSeenAndUnlockArchive();

    final args = Get.arguments as Map<String, dynamic>?;
    Get.offNamed(
      GameConstants.routeResult,
      arguments: args ?? {
        'success': true,
        'levelId': GameConstants.mysteryHookLevel,
        'reward': null,
        'hintsUsed': 0,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GamingBackground(
            child: const SizedBox.expand(),
          ),
          if (_showMessage) _buildSecretMessage(),
          if (_showContinue) _buildContinueButton(),
          AnimatedBuilder(
            animation: _glitchNoise,
            builder: (context, _) {
              if (_glitchCtrl.isAnimating) return _buildGlitchOverlay();
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGlitchOverlay() {
    return IgnorePointer(
      child: Container(
        color: Colors.black.withValues(alpha: 0.1),
        child: CustomPaint(
          painter: _GlitchPainter(
            intensity: _glitchNoise.value,
            seed: DateTime.now().millisecondsSinceEpoch,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }

  Widget _buildSecretMessage() {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '⚠ SYSTEM GLITCH ⚠',
                style: TextStyle(
                  color: AppColors.danger,
                  fontSize: AppDimensions.fontS,
                  letterSpacing: 3,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXL),
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                decoration: BoxDecoration(
                  color: AppColors.backgroundCard.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  border: Border.all(
                    color: AppColors.senderUnknown.withValues(alpha: 0.6),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentCyan.withValues(alpha: 0.2),
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('📩', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(
                          'FROM: UNKNOWN SENDER',
                          style: TextStyle(
                            color: AppColors.senderUnknown,
                            fontSize: AppDimensions.fontS,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.paddingM),
                    Text(
                      'You\'re not supposed to see this. The system has a back door.\n\n'
                      'There are files in the Archive—story fragments. Seven possible endings. '
                      'What you decode changes which one you find.\n\n'
                      'Check the main menu. The Archive is now visible. '
                      'Unlock the rest by going further.',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: AppDimensions.fontM,
                        height: 1.6,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Positioned(
      left: AppDimensions.paddingL,
      right: AppDimensions.paddingL,
      bottom: MediaQuery.of(context).padding.bottom + AppDimensions.paddingL,
      child: ElevatedButton(
        onPressed: _onContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentCyan.withValues(alpha: 0.2),
          foregroundColor: AppColors.accentCyan,
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            side: BorderSide(color: AppColors.accentCyan, width: 2),
          ),
        ),
        child: const Text('CONTINUE'),
      ),
    );
  }
}

class _GlitchPainter extends CustomPainter {
  final double intensity;
  final int seed;

  _GlitchPainter({required this.intensity, required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final rand = math.Random(seed);
    final count = (20 * intensity).toInt().clamp(5, 30);
    for (var i = 0; i < count; i++) {
      final x = rand.nextDouble() * size.width;
      final y = rand.nextDouble() * size.height;
      final w = 2.0 + rand.nextDouble() * 6;
      final h = 1.0 + rand.nextDouble() * 3;
      final opacity = 0.1 + rand.nextDouble() * 0.4;
      canvas.drawRect(
        Rect.fromLTWH(x, y, w, h),
        Paint()..color = Colors.white.withValues(alpha: opacity * intensity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GlitchPainter old) =>
      old.intensity != intensity || old.seed != seed;
}
