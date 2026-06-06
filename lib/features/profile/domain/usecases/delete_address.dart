import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/profile_repository.dart';

final class DeleteAddressUseCase extends UseCase<void, String> {
  const DeleteAddressUseCase(this._repository);

  final IProfileRepository _repository;

  @override
  Future<Result<void>> call(String addressId) {
    return _repository.deleteAddress(addressId);
  }
}
