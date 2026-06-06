import 'package:flutter/foundation.dart';

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
}

@immutable
class Order {
  const Order({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.totalAmount,
    required this.items,
    this.shippingAddress,
  });

  final String id;
  final DateTime createdAt;
  final OrderStatus status;
  final double totalAmount;
  final List<OrderItem> items;
  final Address? shippingAddress;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

@immutable
class OrderItem {
  const OrderItem({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.price,
    required this.quantity,
    this.size,
    this.color,
  });

  final String productId;
  final String productName;
  final String? productImage;
  final double price;
  final int quantity;
  final String? size;
  final String? color;

  double get total => price * quantity;
}

@immutable
class Address {
  const Address({
    required this.label,
    required this.street,
    required this.city,
    required this.country,
  });

  final String label;
  final String street;
  final String city;
  final String country;
}
