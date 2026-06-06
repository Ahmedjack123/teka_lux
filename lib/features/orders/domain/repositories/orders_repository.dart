import '../../../../core/utils/result.dart';
import '../entities/order.dart';

abstract interface class IOrdersRepository {
  Future<Result<List<Order>>> getOrderHistory();
  Future<Result<Order?>> getOrderById(String id);
  Future<Result<void>> placeOrder({
    required List<OrderItem> items,
    required double totalAmount,
    required Address shippingAddress,
  });
}
