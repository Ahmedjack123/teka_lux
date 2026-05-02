enum OnboardingCopyKey {
  craft,
  atelier,
  luxe,
}

class OnboardingSlide {
  const OnboardingSlide({
    required this.imagePath,
    required this.copy,
  });

  final String imagePath;
  final OnboardingCopyKey copy;
}
