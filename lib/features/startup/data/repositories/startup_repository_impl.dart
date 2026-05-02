import '../../domain/repositories/startup_repository.dart';
import '../datasources/startup_local_datasource.dart';

class StartupRepositoryImpl implements StartupRepository {
  const StartupRepositoryImpl(this._localDatasource);

  final StartupLocalDatasource _localDatasource;

  @override
  Future<bool> isOnboardingCompleted() {
    return _localDatasource.isOnboardingCompleted();
  }

  @override
  Future<void> completeOnboarding() {
    return _localDatasource.completeOnboarding();
  }
}
