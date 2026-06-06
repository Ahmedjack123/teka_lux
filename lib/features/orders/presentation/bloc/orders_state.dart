import '../../domain/entities/order.dart';

enum OrdersStatus { initial, loading, success, failure }

class OrdersState {
  const OrdersState({
    required this.status,
    this.orders = const [],
    this.selectedOrder,
    this.errorMessage,
  });

  const OrdersState.initial()
      : status = OrdersStatus.initial,
        orders = const [],
        selectedOrder = null,
        errorMessage = null;

  final OrdersStatus status;
  final List<Order> orders;
  final Order? selectedOrder;
  final String? errorMessage;

  OrdersState copyWith({
    OrdersStatus? status,
    Object? orders = _unset,
    Object? selectedOrder = _unset,
    Object? errorMessage = _unset,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders == _unset ? this.orders : (orders as List<Order>),
      selectedOrder: selectedOrder == _unset
          ? this.selectedOrder
          : (selectedOrder as Order?),
      errorMessage: errorMessage == _unset
          ? this.errorMessage
          : (errorMessage as String?),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrdersState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          orders == other.orders &&
          selectedOrder == other.selectedOrder &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode =>
      status.hashCode ^
      orders.hashCode ^
      selectedOrder.hashCode ^
      errorMessage.hashCode;
}

const Object _unset = Object();
