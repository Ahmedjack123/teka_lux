import '../../../../core/constants/storage_keys.dart';
import '../../../../shared/services/local_storage_service.dart';

class StartupLocalDatasource {
  const StartupLocalDatasource(this._storage);

  final LocalStorageService _storage;

  Future<bool> isOnboardingCompleted() async {
    return _storage.getBool(StorageKeys.onboardingCompleted);
  }

  Future<void> completeOnboarding() {
    return _storage.setBool(StorageKeys.onboardingCompleted, true);
  }
}
