import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase extends UseCase<void, ResetPasswordParams> {
  const ResetPasswordUseCase(this._repository);

  final IAuthRepository _repository;

  @override
  Future<Result<void>> call(ResetPasswordParams params) {
    return _repository.sendPasswordResetEmail(params.email);
  }
}

class ResetPasswordParams {
  const ResetPasswordParams({required this.email});

  final String email;
}
