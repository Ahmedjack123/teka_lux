import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

class CheckEmailVerifiedUseCase extends UseCase<bool, NoParams> {
  const CheckEmailVerifiedUseCase(this._repository);

  final IAuthRepository _repository;

  @override
  Future<Result<bool>> call(NoParams params) {
    return _repository.isCurrentUserEmailVerified();
  }
}
