import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/profile_repository.dart';

final class UpdateProfileUseCase extends UseCase<void, UpdateProfileParams> {
  const UpdateProfileUseCase(this._repository);

  final IProfileRepository _repository;

  @override
  Future<Result<void>> call(UpdateProfileParams params) {
    return _repository.updateProfile(
      name: params.name,
      phoneNumber: params.phoneNumber,
      photoUrl: params.photoUrl,
    );
  }
}

final class UpdateProfileParams {
  const UpdateProfileParams({
    required this.name,
    this.phoneNumber,
    this.photoUrl,
  });

  final String name;
  final String? phoneNumber;
  final String? photoUrl;
}
