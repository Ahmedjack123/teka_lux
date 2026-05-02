abstract class StartupRepository {
  Future<bool> isOnboardingCompleted();

  Future<void> completeOnboarding();
}
