import 'package:flutter/material.dart';

import '../../../../core/theming/theming.dart';
import '../../../../core/utils/device_helper.dart';
import '../../domain/entities/onboarding_slide.dart';
import 'onboarding_controls.dart';
import 'onboarding_slide_view.dart';

class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    required this.slides,
    required this.pageController,
    required this.currentIndex,
    required this.isSaving,
    required this.onPageChanged,
    required this.onNext,
    required this.onSkip,
    super.key,
  });

  final List<OnboardingSlide> slides;
  final PageController pageController;
  final int currentIndex;
  final bool isSaving;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = DeviceHelper.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: slides.length,
                onPageChanged: onPageChanged,
                itemBuilder: (context, index) {
                  return OnboardingSlideView(
                    slide: slides[index],
                    index: index,
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                AppSizes.md,
                horizontalPadding,
                AppSizes.lg,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: DeviceHelper.maxContentWidth(context),
                  ),
                  child: OnboardingControls(
                    currentIndex: currentIndex,
                    slideCount: slides.length,
                    isLastSlide: currentIndex == slides.length - 1,
                    isSaving: isSaving,
                    onNext: onNext,
                    onSkip: onSkip,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
