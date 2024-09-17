import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class AppTheme {
  static const logoFont = 'TrainOne';

  static final lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: AppBarTheme(backgroundColor: AppColors.lightBackground, surfaceTintColor: AppColors.lightBackground),
    brightness: Brightness.light,
  );

  static final darkTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    brightness: Brightness.dark,
  );
}
