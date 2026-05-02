import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle get _serif {
    return GoogleFonts.playfairDisplay(
      color: AppColors.textPrimary,
      letterSpacing: 0,
    );
  }

  static TextStyle get _sans {
    return GoogleFonts.inter(
      color: AppColors.textPrimary,
      letterSpacing: 0,
    );
  }

  static TextStyle get display {
    return _serif.copyWith(
      fontSize: 40,
      height: 1.2,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle get h1 {
    return _serif.copyWith(
      fontSize: 32,
      height: 1.25,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle get h2 {
    return _serif.copyWith(
      fontSize: 24,
      height: 1.3,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle get h3 {
    return _serif.copyWith(
      fontSize: 20,
      height: 1.4,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle get bodyLg {
    return _sans.copyWith(fontSize: 17, height: 1.55);
  }

  static TextStyle get body {
    return _sans.copyWith(fontSize: 15, height: 1.5);
  }

  static TextStyle get label {
    return _sans.copyWith(
      fontSize: 13,
      height: 1.4,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle get caption {
    return _sans.copyWith(
      fontSize: 12,
      height: 1.35,
      color: AppColors.textSecondary,
    );
  }

  static TextStyle get priceLg {
    return _serif.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: AppColors.primaryDark,
    );
  }
}
