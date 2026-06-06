import 'package:flutter/material.dart';

class AppAuthPalette {
  const AppAuthPalette({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.text,
    required this.muted,
    required this.faint,
    required this.line,
    required this.accent,
    required this.onAccent,
    required this.error,
    required this.success,
    required this.shadow,
  });

  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color text;
  final Color muted;
  final Color faint;
  final Color line;
  final Color accent;
  final Color onAccent;
  final Color error;
  final Color success;
  final Color shadow;

  static const light = AppAuthPalette(
    background: Color(0xFFF7F9E8),
    surface: Color(0xFFF7F9E8),
    surfaceAlt: Color(0xFFEFF2DA),
    text: Color(0xFF090D08),
    muted: Color(0xFF3D4630),
    faint: Color(0xFFA9AD9D),
    line: Color(0xFFC8CCB7),
    accent: Color(0xFFC4FF00),
    onAccent: Color(0xFF090D08),
    error: Color(0xFFD33232),
    success: Color(0xFF4F8F28),
    shadow: Color(0x1A090D08),
  );

  static const dark = AppAuthPalette(
    background: Color(0xFF090D08),
    surface: Color(0xFF10150E),
    surfaceAlt: Color(0xFF1A2214),
    text: Color(0xFFF5F8E8),
    muted: Color(0xFFC8D0B8),
    faint: Color(0xFF747D66),
    line: Color(0xFF3C4633),
    accent: Color(0xFFC4FF00),
    onAccent: Color(0xFF090D08),
    error: Color(0xFFFF6D6D),
    success: Color(0xFFC4FF00),
    shadow: Color(0x73000000),
  );

  static AppAuthPalette of(BuildContext context) {
    return MediaQuery.platformBrightnessOf(context) == Brightness.dark
        ? dark
        : light;
  }
}
