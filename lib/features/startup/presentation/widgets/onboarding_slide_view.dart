import 'package:flutter/material.dart';

import '../../../../core/utils/device_helper.dart';
import '../../domain/entities/onboarding_slide.dart';
import 'onboarding_compact_slide.dart';
import 'onboarding_wide_slide.dart';

class OnboardingSlideView extends StatelessWidget {
  const OnboardingSlideView({
    required this.slide,
    required this.index,
    super.key,
  });

  final OnboardingSlide slide;
  final int index;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (DeviceHelper.isWide(context)) {
          return OnboardingWideSlide(slide: slide, index: index);
        }

        return OnboardingCompactSlide(
          slide: slide,
          index: index,
          availableHeight: constraints.maxHeight,
        );
      },
    );
  }
}
