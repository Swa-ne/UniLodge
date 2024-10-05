import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/core/configs/theme/app_theme.dart';

class UnilodgeText extends StatelessWidget {
  const UnilodgeText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'UniLodge',
      style: TextStyle(
        fontFamily: AppTheme.logoFont,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.logoTextColor,
      ),
    );
  }
}
