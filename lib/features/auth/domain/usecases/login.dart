import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase extends UseCase<UserEntity, LoginParams> {
  const LoginUseCase(this._repository);

  final IAuthRepository _repository;

  @override
  Future<Result<UserEntity>> call(LoginParams params) {
    return _repository.signInWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams {
  const LoginParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
