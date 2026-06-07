import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// NOIR Account Hub design tokens extracted from the specification.
/// These colors and styles are scoped to the account-hub screen so they
/// do not bleed into the rest of the app theme.
class NoirAccountHubTheme {
  const NoirAccountHubTheme._();

  static const Color background = Color(0xFFF9FBE5);
  static const Color onBackground = Color(0xFF1A1D10);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color accent = Color(0xFFCCFF00);
  static const Color bottomNavBackground = Color(0xFF1A1D10);
  static const Color bottomNavInactive = Color(0xFF474646);

  static const Color divider = Colors.black12;
  static const Color menuBorder = Color(0x1A1A1D10); // 10% opacity

  static TextStyle anton({
    required double fontSize,
    Color color = onBackground,
    double letterSpacing = 0,
    FontWeight fontWeight = FontWeight.w400,
    double? height,
  }) {
    return GoogleFonts.anton(
      fontSize: fontSize,
      color: color,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight,
      height: height,
    );
  }

  static TextStyle inter({
    required double fontSize,
    Color color = onBackground,
    double letterSpacing = 0,
    FontWeight fontWeight = FontWeight.w400,
    double? height,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      color: color,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight,
      height: height,
    );
  }
}
