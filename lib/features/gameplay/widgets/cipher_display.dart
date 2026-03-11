/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    CipherDisplay widget shows the encrypted message in a
                styled terminal-like box with animated typewriter reveal
                and a collapsible reference guide panel.

---------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:cipher_escape/core/constants/colors.dart';
import 'package:cipher_escape/core/constants/dimensions.dart';
import 'package:cipher_escape/core/theme/text_styles.dart';
import 'package:cipher_escape/models/level_model.dart';
import 'package:cipher_escape/puzzles/cipher_decoder.dart';

class CipherDisplay extends StatefulWidget {
  final LevelModel level;
  final bool showCipherType;

  const CipherDisplay({
    super.key,
    required this.level,
    this.showCipherType = false,
  });

  @override
  State<CipherDisplay> createState() => _CipherDisplayState();
}

class _CipherDisplayState extends State<CipherDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkCtrl;
  bool _showReference = false;
  String _displayedText = '';
  bool _glitchPhase = true;
  static const _glitchChars = r'!@#$%^&*<>?/\|[]{}~`01';

  @override
  void initState() {
    super.initState();
    _blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _runGlitchThenTypewriter();
  }

  String _randomGlitchString(int length, int seed) {
    final full = widget.level.encryptedMessage;
    final buf = StringBuffer();
    for (int i = 0; i < length; i++) {
      if (i < full.length && full[i] != ' ') {
        buf.write(_glitchChars[(seed + i) % _glitchChars.length]);
      } else if (i < full.length) {
        buf.write(' ');
      }
    }
    return buf.toString();
  }

  Future<void> _runGlitchThenTypewriter() async {
    final full = widget.level.encryptedMessage;
    const glitchDurationMs = 650;
    const glitchTickMs = 70;
    int elapsed = 0;
    while (elapsed < glitchDurationMs && mounted) {
      if (mounted) setState(() => _displayedText = _randomGlitchString(full.length, elapsed));
      await Future.delayed(const Duration(milliseconds: glitchTickMs));
      elapsed += glitchTickMs;
    }
    if (!mounted) return;
    _glitchPhase = false;
    setState(() {});
    _typewriterReveal();
  }

  void _typewriterReveal() async {
    final full = widget.level.encryptedMessage;
    _displayedText = '';
    for (int i = 0; i <= full.length; i++) {
      if (!mounted) return;
      await Future.delayed(
          const Duration(milliseconds: AppDimensions.animTypewriter));
      if (mounted) setState(() => _displayedText = full.substring(0, i));
    }
  }

  @override
  void dispose() {
    _blinkCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final decoder = CipherDecoder.forType(widget.level.cipherType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sender banner
        _SenderBanner(level: widget.level),
        const SizedBox(height: AppDimensions.paddingS),

        // Cipher type label
        if (widget.showCipherType)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.paddingS),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
                vertical: AppDimensions.paddingXS,
              ),
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
                border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.3)),
              ),
              child: Text(
                '⚙ ${widget.level.cipherLabel}',
                style: const TextStyle(
                  color: AppColors.accentCyan,
                  fontSize: AppDimensions.fontS,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),

        // Encrypted message box — terminal / hacker device style with scanlines
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF0D1218),
                      AppColors.accentCyan.withValues(alpha: 0.04),
                      const Color(0xFF0A0E14),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.6), width: 2),
                  boxShadow: [
                    ...AppColors.glowShadow(AppColors.accentCyan, blur: 20, spread: 0),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '> INCOMING TRANSMISSION',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: AppDimensions.fontXS,
                        fontFamily: 'monospace',
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingS),
                    AnimatedBuilder(
                      animation: _blinkCtrl,
                      builder: (context, child) {
                        final full = widget.level.encryptedMessage;
                        final cursor = !_glitchPhase && _displayedText.length < full.length
                            ? (_blinkCtrl.value > 0.5 ? '█' : ' ')
                            : (_glitchPhase ? '▌' : '');
                        return Text(
                          '$_displayedText$cursor',
                          style: AppTextStyles.cipherDisplay.copyWith(
                            color: _glitchPhase
                                ? AppColors.accentCyan.withValues(alpha: 0.9)
                                : AppTextStyles.cipherDisplay.color,
                          ),
                          maxLines: 12,
                          overflow: TextOverflow.fade,
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Scanline overlay
              Positioned.fill(
                child: IgnorePointer(
                  child: LayoutBuilder(
                    builder: (_, c) {
                      return CustomPaint(
                        size: c.biggest,
                        painter: _ScanlinePainter(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppDimensions.paddingS),

        // Reference guide toggle
        GestureDetector(
          onTap: () => setState(() => _showReference = !_showReference),
          child: Row(
            children: [
              Icon(
                _showReference ? Icons.expand_less : Icons.expand_more,
                color: AppColors.textMuted,
                size: AppDimensions.iconS,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _showReference ? 'Hide reference guide' : 'Show ${decoder.cipherName} reference',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: AppDimensions.fontS,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        if (_showReference) ...[
          const SizedBox(height: AppDimensions.paddingS),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Text(
              decoder.referenceGuide,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppDimensions.fontS,
                fontFamily: 'monospace',
                height: 1.6,
              ),
              maxLines: 20,
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ],
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.03)
      ..strokeWidth = 1;
    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SenderBanner extends StatelessWidget {
  final LevelModel level;
  const _SenderBanner({required this.level});

  Color get _senderColor {
    switch (level.sender) {
      case 'Helper':
        return AppColors.senderHelper;
      case 'Overseer AI':
        return AppColors.senderEnemy;
      case 'Future Self':
        return AppColors.senderFuture;
      case 'Past Prisoner':
        return AppColors.senderGhost;
      default:
        return AppColors.senderUnknown;
    }
  }

  String get _senderDisplayName {
    switch (level.sender) {
      case 'Helper':
        return 'Unknown Sender';
      case 'Overseer AI':
        return 'Enemy AI';
      case 'Future Self':
        return 'Future You';
      case 'Past Prisoner':
        return 'Past Prisoner';
      default:
        return level.sender.isEmpty ? 'Unknown Sender' : level.sender;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _senderColor;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Text(level.senderIcon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: AppDimensions.paddingS),
          Expanded(
            child: Text(
              'FROM: $_senderDisplayName'.toUpperCase(),
              style: AppTextStyles.senderLabel.copyWith(
                color: color,
                fontFamily: 'monospace',
                letterSpacing: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingS),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: color, blurRadius: 6)],
            ),
          ),
        ],
      ),
    );
  }
}
