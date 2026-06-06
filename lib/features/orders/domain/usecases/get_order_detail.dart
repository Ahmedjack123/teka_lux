import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/order.dart';
import '../repositories/orders_repository.dart';

final class GetOrderDetailParams {
  const GetOrderDetailParams(this.id);

  final String id;
}

final class GetOrderDetailUseCase extends UseCase<Order?, GetOrderDetailParams> {
  const GetOrderDetailUseCase(this._repository);

  final IOrdersRepository _repository;

  @override
  Future<Result<Order?>> call(GetOrderDetailParams params) {
    return _repository.getOrderById(params.id);
  }
}
