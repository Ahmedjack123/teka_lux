import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_input_styles.dart';
import 'app_text_styles.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.accentWarm,
      surface: AppColors.surface,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: scheme,
      textTheme: TextTheme(
        displayLarge: AppTextStyles.display,
        headlineLarge: AppTextStyles.h1,
        headlineMedium: AppTextStyles.h2,
        titleLarge: AppTextStyles.h3,
        bodyLarge: AppTextStyles.bodyLg,
        bodyMedium: AppTextStyles.body,
        labelLarge: AppTextStyles.label,
        bodySmall: AppTextStyles.caption,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.authBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      chipTheme: ChipThemeData(
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.surfaceElevated,
        disabledColor: AppColors.surface,
        side: const BorderSide(color: AppColors.divider),
        labelStyle: AppTextStyles.label.copyWith(color: AppColors.textPrimary),
        secondaryLabelStyle: AppTextStyles.label.copyWith(
          color: AppColors.textInverse,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: AppInputStyles.theme(),
    );
  }

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.accentWarm,
      surface: AppColors.darkSurface,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: scheme,
      textTheme: TextTheme(
        displayLarge: AppTextStyles.display.copyWith(
          color: const Color(0xFFF5F8E8),
        ),
        headlineLarge: AppTextStyles.h1.copyWith(
          color: const Color(0xFFF5F8E8),
        ),
        headlineMedium: AppTextStyles.h2.copyWith(
          color: const Color(0xFFF5F8E8),
        ),
        titleLarge: AppTextStyles.h3.copyWith(color: const Color(0xFFF5F8E8)),
        bodyLarge: AppTextStyles.bodyLg.copyWith(
          color: const Color(0xFFC8D0B8),
        ),
        bodyMedium: AppTextStyles.body.copyWith(
          color: const Color(0xFFC8D0B8),
        ),
        labelLarge: AppTextStyles.label.copyWith(
          color: const Color(0xFFF5F8E8),
        ),
        bodySmall: AppTextStyles.caption.copyWith(
          color: const Color(0xFF747D66),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFFF5F8E8)),
        titleTextStyle: TextStyle(
          color: Color(0xFFF5F8E8),
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF3C4633),
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: AppInputStyles.theme(),
    );
  }
}
