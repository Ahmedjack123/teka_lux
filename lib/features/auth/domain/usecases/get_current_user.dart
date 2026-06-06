import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUseCase extends UseCase<UserEntity?, NoParams> {
  const GetCurrentUserUseCase(this._repository);

  final IAuthRepository _repository;

  @override
  Future<Result<UserEntity?>> call(NoParams params) {
    return _repository.getCurrentUser();
  }
}
