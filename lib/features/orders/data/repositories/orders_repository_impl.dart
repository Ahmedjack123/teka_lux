import '../../../../core/errors/auth_error_code.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_datasource.dart';

final class OrdersRepositoryImpl implements IOrdersRepository {
  const OrdersRepositoryImpl(this._remoteDatasource);

  final OrdersRemoteDatasource _remoteDatasource;

  @override
  Future<Result<List<Order>>> getOrderHistory() {
    return _guard(() => _remoteDatasource.getOrderHistory());
  }

  @override
  Future<Result<Order?>> getOrderById(String id) {
    return _guard(() => _remoteDatasource.getOrderById(id));
  }

  @override
  Future<Result<void>> placeOrder({
    required List<OrderItem> items,
    required double totalAmount,
    required Address shippingAddress,
  }) {
    return _guard(
      () => _remoteDatasource.placeOrder(
        items: items,
        totalAmount: totalAmount,
        shippingAddress: shippingAddress,
      ),
    );
  }

  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Result<T>.success(await action());
    } on AuthException catch (exception) {
      return Result<T>.failure(exception.toFailure());
    } catch (exception, stackTrace) {
      return Result<T>.failure(
        AuthFailure(
          errorCode: AuthErrorCode.unknown,
          debugMessage: exception.toString(),
          cause: exception,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
