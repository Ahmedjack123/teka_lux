import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_order_history.dart';
import '../../domain/usecases/get_order_detail.dart';
import '../../domain/usecases/place_order.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit({
    required GetOrderHistoryUseCase getOrderHistory,
    required GetOrderDetailUseCase getOrderDetail,
    required PlaceOrderUseCase placeOrder,
  })  : _getOrderHistory = getOrderHistory,
        _getOrderDetail = getOrderDetail,
        _placeOrder = placeOrder,
        super(const OrdersState.initial());

  final GetOrderHistoryUseCase _getOrderHistory;
  final GetOrderDetailUseCase _getOrderDetail;
  final PlaceOrderUseCase _placeOrder;

  Future<void> loadOrders() async {
    emit(state.copyWith(status: OrdersStatus.loading));
    final result = await _getOrderHistory(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: OrdersStatus.failure,
          errorMessage: failure.localizedMessage,
        ),
      ),
      (orders) => emit(
        state.copyWith(
          status: OrdersStatus.success,
          orders: orders,
        ),
      ),
    );
  }

  Future<void> loadOrderDetail(String id) async {
    emit(state.copyWith(status: OrdersStatus.loading));
    final result = await _getOrderDetail(GetOrderDetailParams(id));
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: OrdersStatus.failure,
          errorMessage: failure.localizedMessage,
        ),
      ),
      (order) => emit(
        state.copyWith(
          status: OrdersStatus.success,
          selectedOrder: order,
        ),
      ),
    );
  }

  Future<bool> createOrder(PlaceOrderParams params) async {
    emit(state.copyWith(status: OrdersStatus.loading));
    final result = await _placeOrder(params);
    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: OrdersStatus.failure,
            errorMessage: failure.localizedMessage,
          ),
        );
        return false;
      },
      (_) {
        emit(state.copyWith(status: OrdersStatus.success));
        return true;
      },
    );
  }
}
