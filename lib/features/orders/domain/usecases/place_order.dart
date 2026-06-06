import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/order.dart';
import '../repositories/orders_repository.dart';

final class PlaceOrderParams {
  const PlaceOrderParams({
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
  });

  final List<OrderItem> items;
  final double totalAmount;
  final Address shippingAddress;
}

final class PlaceOrderUseCase extends UseCase<void, PlaceOrderParams> {
  const PlaceOrderUseCase(this._repository);

  final IOrdersRepository _repository;

  @override
  Future<Result<void>> call(PlaceOrderParams params) {
    return _repository.placeOrder(
      items: params.items,
      totalAmount: params.totalAmount,
      shippingAddress: params.shippingAddress,
    );
  }
}
