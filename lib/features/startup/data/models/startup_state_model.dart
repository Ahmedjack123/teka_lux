import '../../domain/entities/startup_state.dart';

class StartupStateModel {
  const StartupStateModel({
    required this.onboardingCompleted,
  });

  final bool onboardingCompleted;

  StartupDestination get destination {
    return onboardingCompleted
        ? StartupDestination.login
        : StartupDestination.onboarding;
  }
}
