import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

class VerifyEmailUseCase extends UseCase<void, NoParams> {
  const VerifyEmailUseCase(this._repository);

  final IAuthRepository _repository;

  @override
  Future<Result<void>> call(NoParams params) {
    return _repository.verifyEmail();
  }
}
