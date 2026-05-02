import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/onboarding_slide_model.dart';
import '../../domain/entities/onboarding_slide.dart';
import 'startup_provider.dart';

final onboardingSlidesProvider = Provider<List<OnboardingSlide>>((ref) {
  return OnboardingSlideModel.defaults;
});

final onboardingControllerProvider =
    AsyncNotifierProvider<OnboardingController, void>(OnboardingController.new);

class OnboardingController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> complete() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final completeOnboarding =
          await ref.read(completeOnboardingUsecaseProvider.future);
      await completeOnboarding();
      ref.invalidate(startupDestinationProvider);
    });
  }
}
