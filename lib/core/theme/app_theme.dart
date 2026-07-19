import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        error: AppColors.danger,
        surface: AppColors.surface,
      ),
      cardColor: AppColors.surfaceElevated,
      dividerColor: AppColors.divider,
      textTheme: TextTheme(
        headlineSmall: AppTextStyles.heading,
        titleMedium: AppTextStyles.subheading,
        bodyMedium: AppTextStyles.body,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
    );
  }
}
