import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/address.dart';
import '../repositories/profile_repository.dart';

final class SaveAddressUseCase extends UseCase<void, Address> {
  const SaveAddressUseCase(this._repository);

  final IProfileRepository _repository;

  @override
  Future<Result<void>> call(Address params) {
    return _repository.saveAddress(params);
  }
}
