import 'package:flutter/material.dart';

import '../../../../core/theming/theming.dart';
import '../../../../core/utils/device_helper.dart';
import '../../domain/entities/onboarding_slide.dart';
import 'onboarding_image_panel.dart';
import 'onboarding_slide_copy.dart';

class OnboardingCompactSlide extends StatelessWidget {
  const OnboardingCompactSlide({
    required this.slide,
    required this.index,
    required this.availableHeight,
    super.key,
  });

  final OnboardingSlide slide;
  final int index;
  final double availableHeight;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: DeviceHelper.horizontalPadding(context),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: availableHeight),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: AppSizes.md),
            OnboardingImagePanel(
              imagePath: slide.imagePath,
              index: index,
              height: DeviceHelper.onboardingImageHeight(availableHeight),
            ),
            const SizedBox(height: AppSizes.xl),
            OnboardingSlideCopy(slide: slide, index: index),
            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }
}
