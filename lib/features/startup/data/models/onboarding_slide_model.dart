import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/onboarding_slide.dart';

class OnboardingSlideModel extends OnboardingSlide {
  const OnboardingSlideModel({
    required super.imagePath,
    required super.copy,
  });

  static const defaults = [
    OnboardingSlideModel(
      imagePath: AppAssets.onboardingFirst,
      copy: OnboardingCopyKey.craft,
    ),
    OnboardingSlideModel(
      imagePath: AppAssets.onboardingSecond,
      copy: OnboardingCopyKey.atelier,
    ),
    OnboardingSlideModel(
      imagePath: AppAssets.onboardingThird,
      copy: OnboardingCopyKey.luxe,
    ),
  ];
}
