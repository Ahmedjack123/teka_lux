import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

final class GetProfileUseCase extends UseCase<UserProfile?, NoParams> {
  const GetProfileUseCase(this._repository);

  final IProfileRepository _repository;

  @override
  Future<Result<UserProfile?>> call(NoParams params) {
    return _repository.getProfile();
  }
}
