import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theming/theming.dart';

class OnboardingImagePanel extends StatelessWidget {
  const OnboardingImagePanel({
    required this.imagePath,
    required this.index,
    required this.height,
    super.key,
  });

  final String imagePath;
  final int index;
  final double height;

  @override
  Widget build(BuildContext context) {
    final alignment = switch (index) {
      0 => Alignment.center,
      1 => Alignment.topCenter,
      _ => Alignment.center,
    };

    return SizedBox(
      width: double.infinity,
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final panelWidth = math.min(constraints.maxWidth, height * .72);

          return Center(
            child: Container(
              width: panelWidth,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textStrong.withValues(alpha: .08),
                    blurRadius: 24,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                alignment: alignment,
                filterQuality: FilterQuality.high,
                isAntiAlias: true,
              ),
            ),
          );
        },
      ),
    );
  }
}
