/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Loading indicator widget with a neon animated ring
                and optional message, used during asset/data loading.

---------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:cipher_escape/core/constants/colors.dart';
import 'package:cipher_escape/core/constants/dimensions.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final Color? color;

  const LoadingWidget({super.key, this.message, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.accentCyan;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(c),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppDimensions.paddingM),
            Text(
              message!,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppDimensions.fontM,
                fontFamily: 'monospace',
                letterSpacing: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
