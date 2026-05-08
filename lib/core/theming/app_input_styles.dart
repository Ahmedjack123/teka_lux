import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_sizes.dart';
import 'app_text_styles.dart';

class AppInputStyles {
  const AppInputStyles._();

  static InputDecorationTheme theme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputFill,
      border: _border(),
      enabledBorder: _border(
        borderSide: const BorderSide(color: AppColors.divider, width: 1),
      ),
      focusedBorder: _border(
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: _border(
        borderSide: const BorderSide(color: AppColors.error, width: 1.2),
      ),
      focusedErrorBorder: _border(
        borderSide: const BorderSide(color: AppColors.error, width: 1.2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: 17,
      ),
      hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
      errorStyle: AppTextStyles.caption.copyWith(color: AppColors.error),
    );
  }

  static OutlineInputBorder border({
    double radius = AppSizes.radiusMd,
    BorderSide borderSide = BorderSide.none,
  }) {
    return _border(radius: radius, borderSide: borderSide);
  }

  static OutlineInputBorder _border({
    double radius = AppSizes.radiusMd,
    BorderSide borderSide = BorderSide.none,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: borderSide,
    );
  }
}
