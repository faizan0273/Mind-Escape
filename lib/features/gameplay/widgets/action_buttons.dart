/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    ActionButtons widget renders the three choice buttons
                during gameplay. Highlights correct/wrong answers after
                selection with appropriate color feedback.

---------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:cipher_escape/core/constants/colors.dart';
import 'package:cipher_escape/core/constants/dimensions.dart';
import 'package:cipher_escape/models/level_model.dart';

enum ChoiceState { idle, correct, wrong, disabled }

class ActionButtons extends StatelessWidget {
  final List<ChoiceModel> choices;
  final int? selectedChoiceId;
  final bool revealed;
  final void Function(ChoiceModel) onChoiceTap;

  const ActionButtons({
    super.key,
    required this.choices,
    required this.selectedChoiceId,
    required this.revealed,
    required this.onChoiceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: choices.map((choice) {
        ChoiceState state = ChoiceState.idle;
        if (revealed) {
          if (choice.id == selectedChoiceId) {
            state = choice.isCorrect ? ChoiceState.correct : ChoiceState.wrong;
          } else if (choice.isCorrect) {
            state = ChoiceState.correct;
          } else {
            state = ChoiceState.disabled;
          }
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.paddingM),
          child: _ChoiceButton(
            choice: choice,
            state: state,
            onTap: (!revealed && selectedChoiceId == null)
                ? () => onChoiceTap(choice)
                : null,
          ),
        );
      }).toList(),
    );
  }
}

class _ChoiceButton extends StatefulWidget {
  final ChoiceModel choice;
  final ChoiceState state;
  final VoidCallback? onTap;

  const _ChoiceButton({
    required this.choice,
    required this.state,
    this.onTap,
  });

  @override
  State<_ChoiceButton> createState() => _ChoiceButtonState();
}

class _ChoiceButtonState extends State<_ChoiceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shake;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shake = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _shake, curve: Curves.elasticIn),
    );
  }

  @override
  void didUpdateWidget(_ChoiceButton old) {
    super.didUpdateWidget(old);
    if (widget.state == ChoiceState.wrong && old.state != ChoiceState.wrong) {
      _shake.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  Color get _borderColor {
    switch (widget.state) {
      case ChoiceState.correct:
        return AppColors.success;
      case ChoiceState.wrong:
        return AppColors.danger;
      case ChoiceState.disabled:
        return AppColors.borderColor;
      case ChoiceState.idle:
        return AppColors.accentPurple.withValues(alpha: 0.5);
    }
  }

  Color get _bgColor {
    switch (widget.state) {
      case ChoiceState.correct:
        return AppColors.success.withValues(alpha: 0.18);
      case ChoiceState.wrong:
        return AppColors.danger.withValues(alpha: 0.18);
      case ChoiceState.disabled:
        return AppColors.backgroundCard;
      case ChoiceState.idle:
        return AppColors.backgroundCard;
    }
  }

  List<BoxShadow>? get _boxShadow {
    switch (widget.state) {
      case ChoiceState.correct:
        return AppColors.glowShadow(AppColors.success, blur: 20, spread: 0);
      case ChoiceState.wrong:
        return AppColors.glowShadow(AppColors.danger, blur: 16, spread: 0);
      case ChoiceState.idle:
        return [
          BoxShadow(
            color: AppColors.accentPurple.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ];
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnim,
      builder: (_, child) => Transform.translate(
        offset: Offset(
          _shake.isAnimating
              ? (_shakeAnim.value * ((_shake.value * 10).floor().isOdd ? -1 : 1))
              : 0,
          0,
        ),
        child: child,
      ),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: AppDimensions.actionButtonHeight + 4,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
          decoration: BoxDecoration(
            gradient: widget.state == ChoiceState.idle
                ? AppColors.cardGradient(AppColors.accentPurple)
                : null,
            color: widget.state != ChoiceState.idle ? _bgColor : null,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(
              color: _borderColor,
              width: widget.state == ChoiceState.idle ? 2 : 1.5,
            ),
            boxShadow: _boxShadow,
          ),
          child: Row(
            children: [
              Text(
                '>',
                style: TextStyle(
                  color: widget.state == ChoiceState.idle
                      ? AppColors.accentCyan
                      : (widget.state == ChoiceState.correct
                          ? AppColors.success
                          : widget.state == ChoiceState.wrong
                              ? AppColors.danger
                              : AppColors.textMuted),
                  fontSize: AppDimensions.fontM,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.choice.text.toUpperCase(),
                  style: TextStyle(
                    color: widget.state == ChoiceState.disabled
                        ? AppColors.textMuted
                        : AppColors.textPrimary,
                    fontSize: AppDimensions.fontM,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                    fontFamily: 'monospace',
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.state == ChoiceState.correct)
                const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 28)
              else if (widget.state == ChoiceState.wrong)
                const Icon(Icons.cancel_rounded, color: AppColors.danger, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
