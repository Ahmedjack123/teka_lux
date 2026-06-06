import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/order.dart';
import '../repositories/orders_repository.dart';

final class GetOrderHistoryUseCase extends UseCase<List<Order>, NoParams> {
  const GetOrderHistoryUseCase(this._repository);

  final IOrdersRepository _repository;

  @override
  Future<Result<List<Order>>> call(NoParams params) {
    return _repository.getOrderHistory();
  }
}
