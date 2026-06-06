import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/address.dart';
import '../repositories/profile_repository.dart';

final class GetAddressesUseCase extends UseCase<List<Address>, NoParams> {
  const GetAddressesUseCase(this._repository);

  final IProfileRepository _repository;

  @override
  Future<Result<List<Address>>> call(NoParams params) {
    return _repository.getAddresses();
  }
}
