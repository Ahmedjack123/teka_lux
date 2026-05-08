import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

final class SignInWithGoogleUseCase extends UseCase<UserEntity, NoParams> {
  const SignInWithGoogleUseCase(this._repository);

  final IAuthRepository _repository;

  @override
  Future<Result<UserEntity>> call(NoParams params) {
    return _repository.signInWithGoogle();
  }
}
