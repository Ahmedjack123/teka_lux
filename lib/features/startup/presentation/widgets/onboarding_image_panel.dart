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
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            alignment: alignment,
            filterQuality: FilterQuality.high,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background.withValues(alpha: .08),
                  AppColors.background.withValues(alpha: .18),
                  AppColors.background.withValues(alpha: .96),
                ],
                stops: const [0, .62, 1],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
