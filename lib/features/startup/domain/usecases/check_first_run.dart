import '../repositories/startup_repository.dart';

class CheckFirstRun {
  const CheckFirstRun(this._repository);

  final StartupRepository _repository;

  Future<bool> call() async {
    final isCompleted = await _repository.isOnboardingCompleted();
    return !isCompleted;
  }
}
