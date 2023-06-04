import 'package:flutter/material.dart';
import 'package:roqqu_binance/src/core/constants/app_colors.dart';

bool isLightMode(BuildContext context) {
  Brightness brightness = Theme.of(context).brightness;
  return brightness == Brightness.light;
}

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.scaffoldLightBackground,
    primaryColor: AppColors.angelWhitePrimary,
    colorScheme: const ColorScheme.light().copyWith(
      primary: AppColors.angelWhitePrimary,
      secondary: AppColors.blackTintTwoSecondary,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.scaffoldDarkBackground,
    primaryColor: AppColors.rockBlackPrimary,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: AppColors.rockBlackPrimary,
      secondary: AppColors.blackTintThreeSecondary,
    ),
  );
}
