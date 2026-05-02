import 'package:flutter/material.dart';

import '../../../../core/theming/theming.dart';

class OnboardingPageIndicators extends StatelessWidget {
  const OnboardingPageIndicators({
    required this.currentIndex,
    required this.count,
    super.key,
  });

  final int currentIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = AppSizes.xs;
        final maxIndicatorWidth =
            (constraints.maxWidth - (gap * 2 * count)) / count;
        final indicatorWidth = maxIndicatorWidth.clamp(48.0, 86.0);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(count, (index) {
            final isActive = index == currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: indicatorWidth,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: gap),
              decoration: BoxDecoration(
                color:
                    isActive ? AppColors.primaryDark : const Color(0xFFE5DDD4),
                borderRadius: BorderRadius.circular(AppSizes.radiusPill),
              ),
            );
          }),
        );
      },
    );
  }
}
