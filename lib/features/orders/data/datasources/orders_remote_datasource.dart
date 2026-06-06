import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException, SupabaseClient;

import '../../../../core/errors/auth_error_code.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/supabase_exceptions.dart';
import '../../domain/entities/order.dart';

abstract interface class OrdersRemoteDatasource {
  Future<List<Order>> getOrderHistory();
  Future<Order?> getOrderById(String id);
  Future<void> placeOrder({
    required List<OrderItem> items,
    required double totalAmount,
    required Address shippingAddress,
  });
}

final class SupabaseOrdersRemoteDatasource implements OrdersRemoteDatasource {
  SupabaseOrdersRemoteDatasource({
    required SupabaseClient supabaseClient,
    required FirebaseAuth firebaseAuth,
  })  : _supabase = supabaseClient,
        _firebaseAuth = firebaseAuth;

  final SupabaseClient _supabase;
  final FirebaseAuth _firebaseAuth;

  String? get _userId => _firebaseAuth.currentUser?.uid;

  @override
  Future<List<Order>> getOrderHistory() async {
    final userId = _userId;
    if (userId == null) {
      throw const AuthException(errorCode: AuthErrorCode.userNotFound);
    }

    try {
      final response = await _supabase
          .from('orders')
          .select('*, order_items(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return response
          .map((json) => _mapOrderFromJson(json))
          .toList();
    } on PostgrestException catch (exception, stackTrace) {
      throw SupabaseExceptionMapper.toAuthException(exception, stackTrace);
    }
  }

  @override
  Future<Order?> getOrderById(String id) async {
    final userId = _userId;
    if (userId == null) {
      throw const AuthException(errorCode: AuthErrorCode.userNotFound);
    }

    try {
      final response = await _supabase
          .from('orders')
          .select('*, order_items(*)')
          .eq('id', id)
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;
      return _mapOrderFromJson(response);
    } on PostgrestException catch (exception, stackTrace) {
      throw SupabaseExceptionMapper.toAuthException(exception, stackTrace);
    }
  }

  @override
  Future<void> placeOrder({
    required List<OrderItem> items,
    required double totalAmount,
    required Address shippingAddress,
  }) async {
    final userId = _userId;
    if (userId == null) {
      throw const AuthException(errorCode: AuthErrorCode.userNotFound);
    }

    try {
      final orderResponse = await _supabase
          .from('orders')
          .insert({
            'user_id': userId,
            'status': OrderStatus.pending.name,
            'total_amount': totalAmount,
            'shipping_address': {
              'label': shippingAddress.label,
              'street': shippingAddress.street,
              'city': shippingAddress.city,
              'country': shippingAddress.country,
            },
          })
          .select('id')
          .single();

      final orderId = orderResponse['id'] as String;

      final orderItemsPayload = items
          .map(
            (item) => {
              'order_id': orderId,
              'product_id': item.productId,
              'product_name': item.productName,
              'product_image': item.productImage,
              'price': item.price,
              'quantity': item.quantity,
              'size': item.size,
              'color': item.color,
            },
          )
          .toList();

      await _supabase.from('order_items').insert(orderItemsPayload);
    } on PostgrestException catch (exception, stackTrace) {
      throw SupabaseExceptionMapper.toAuthException(exception, stackTrace);
    }
  }

  Order _mapOrderFromJson(Map<String, dynamic> json) {
    final itemsJson = (json['order_items'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();

    return Order(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      status: OrderStatus.values.byName(json['status'] as String),
      totalAmount: (json['total_amount'] as num).toDouble(),
      items: itemsJson.map(_mapOrderItemFromJson).toList(),
      shippingAddress: json['shipping_address'] != null
          ? _mapAddressFromJson(
              json['shipping_address'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  OrderItem _mapOrderItemFromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      productImage: json['product_image'] as String?,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      size: json['size'] as String?,
      color: json['color'] as String?,
    );
  }

  Address _mapAddressFromJson(Map<String, dynamic> json) {
    return Address(
      label: json['label'] as String,
      street: json['street'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
    );
  }
}
