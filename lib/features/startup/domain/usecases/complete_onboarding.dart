import '../repositories/startup_repository.dart';

class CompleteOnboarding {
  const CompleteOnboarding(this._repository);

  final StartupRepository _repository;

  Future<void> call() {
    return _repository.completeOnboarding();
  }
}
