import 'package:flutter/material.dart';

import '../../../../core/theming/theming.dart';
import '../../domain/entities/onboarding_slide.dart';
import 'onboarding_image_panel.dart';
import 'onboarding_slide_copy.dart';

class OnboardingWideSlide extends StatelessWidget {
  const OnboardingWideSlide({
    required this.slide,
    required this.index,
    super.key,
  });

  final OnboardingSlide slide;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.xxl,
        vertical: AppSizes.xl,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 560),
        child: Row(
          children: [
            Expanded(
              child: OnboardingImagePanel(
                imagePath: slide.imagePath,
                index: index,
                height: 560,
              ),
            ),
            const SizedBox(width: AppSizes.xxxl),
            Expanded(
              child: Center(
                child: OnboardingSlideCopy(
                  slide: slide,
                  index: index,
                  alignLeft: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
