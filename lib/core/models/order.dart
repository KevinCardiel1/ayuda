// File: lib/core/models/order.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

enum OrderStatus { pending, processing, shipped, delivered, cancelled, completed }

enum PaymentStatus { pending, paid, failed, refunded }

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String productId,
    required String productName,
    required int quantity,
    required double price,
    String? imageUrl,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);
}

@freezed
class Order with _$Order {
  const Order._();

  const factory Order({
    String? id,
    required String userId,
    required List<OrderItem> items,
    required DateTime orderDate,
    required double totalAmount,
    @Default(OrderStatus.pending) OrderStatus status,
    @Default(PaymentStatus.pending) PaymentStatus paymentStatus,
    String? paymentMethod,
    String? shippingAddress,
    String? notes,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  factory Order.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Order.fromJson(data).copyWith(id: doc.id);
  }

  Map<String, dynamic> toFirestore() {
    return toJson()..remove('id');
  }
}
