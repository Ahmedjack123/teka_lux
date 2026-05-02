import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_sizes.dart';
import 'app_text_styles.dart';

class AppButtonStyles {
  const AppButtonStyles._();

  static ButtonStyle primary({
    double radius = AppSizes.radiusLg,
    double fontSize = 16,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      disabledBackgroundColor: AppColors.primarySoft.withValues(alpha: .45),
      foregroundColor: AppColors.textInverse,
      disabledForegroundColor: AppColors.textInverse.withValues(alpha: .72),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      textStyle: AppTextStyles.label.copyWith(fontSize: fontSize),
    );
  }

  static ButtonStyle secondary({
    double radius = AppSizes.radiusLg,
    double fontSize = 16,
  }) {
    return OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryDark,
      disabledForegroundColor: AppColors.textSecondary,
      side: const BorderSide(color: AppColors.primary, width: 1.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      textStyle: AppTextStyles.label.copyWith(fontSize: fontSize),
    );
  }

  static ButtonStyle ghost({
    double radius = AppSizes.radiusLg,
    double fontSize = 15,
  }) {
    return TextButton.styleFrom(
      foregroundColor: AppColors.primaryDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      textStyle: AppTextStyles.label.copyWith(fontSize: fontSize),
    );
  }

  static ButtonStyle filledPill({
    required Color backgroundColor,
    required Color foregroundColor,
    double fontSize = 17,
    double letterSpacing = .8,
  }) {
    return ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: backgroundColor,
      disabledBackgroundColor: backgroundColor.withValues(alpha: .55),
      foregroundColor: foregroundColor,
      disabledForegroundColor: foregroundColor.withValues(alpha: .7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      textStyle: AppTextStyles.label.copyWith(
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
