import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theming/theming.dart';

class ForgotPasswordBackdrop extends StatelessWidget {
  const ForgotPasswordBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: AppColors.authBackground),
        Positioned(
          top: -90,
          right: -120,
          child: Transform.rotate(
            angle: -.16,
            child: _SoftPanel(
              width: 320,
              height: 760,
              opacity: .09,
              color: AppColors.primary,
            ),
          ),
        ),
        Positioned(
          bottom: -210,
          left: -170,
          child: Transform.rotate(
            angle: .18,
            child: _SoftPanel(
              width: 560,
              height: 760,
              opacity: .055,
              color: AppColors.primaryDark,
            ),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: ColoredBox(
              color: AppColors.authBackground.withValues(alpha: .72),
            ),
          ),
        ),
      ],
    );
  }
}

class _SoftPanel extends StatelessWidget {
  const _SoftPanel({
    required this.width,
    required this.height,
    required this.opacity,
    required this.color,
  });

  final double width;
  final double height;
  final double opacity;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
    );
  }
}
