import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle get _display {
    return GoogleFonts.spaceGrotesk(
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
    return _display.copyWith(
      fontSize: 44,
      height: 1.02,
      fontWeight: FontWeight.w800,
    );
  }

  static TextStyle get h1 {
    return _display.copyWith(
      fontSize: 34,
      height: 1.08,
      fontWeight: FontWeight.w800,
    );
  }

  static TextStyle get h2 {
    return _display.copyWith(
      fontSize: 26,
      height: 1.16,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle get h3 {
    return _display.copyWith(
      fontSize: 21,
      height: 1.24,
      fontWeight: FontWeight.w700,
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
      fontSize: 13.5,
      height: 1.4,
      fontWeight: FontWeight.w800,
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
    return _display.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      color: AppColors.textStrong,
    );
  }
}
