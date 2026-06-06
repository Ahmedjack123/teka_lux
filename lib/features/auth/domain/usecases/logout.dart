import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

class SignOutUseCase extends UseCase<void, NoParams> {
  const SignOutUseCase(this._repository);

  final IAuthRepository _repository;

  @override
  Future<Result<void>> call(NoParams params) {
    return _repository.signOut();
  }
}
