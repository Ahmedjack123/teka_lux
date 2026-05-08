import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

final class RegisterUseCase extends UseCase<UserEntity, RegisterParams> {
  const RegisterUseCase(this._repository);

  final IAuthRepository _repository;

  @override
  Future<Result<UserEntity>> call(RegisterParams params) {
    return _repository.signUp(
      email: params.email,
      password: params.password,
      name: params.name,
      phoneNumber: params.phoneNumber,
    );
  }
}

final class RegisterParams {
  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
    required this.phoneNumber,
  });

  final String email;
  final String password;
  final String name;
  final String phoneNumber;
}
