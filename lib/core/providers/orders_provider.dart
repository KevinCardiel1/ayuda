
// File: lib/core/providers/orders_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/models/order.dart';
import 'package:floreria_ajolote/core/providers/firebase_provider.dart';

final ordersProvider = StreamProvider<List<Order>>((ref) {
  return ref.watch(firebaseProvider).getOrders();
});

final orderProvider = StreamProvider.family<Order?, String>((ref, id) {
  return ref.watch(firebaseProvider).getOrder(id);
});


final orderNotifierProvider = StateNotifierProvider<OrderNotifier, AsyncValue<List<Order>>>((ref) {
  return OrderNotifier(ref);
});

class OrderNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  final Ref _ref;

  OrderNotifier(this._ref) : super(const AsyncValue.loading()) {
    _ref.watch(firebaseProvider).getOrders().listen((orders) {
      state = AsyncValue.data(orders);
    });
  }

  Future<void> addOrder(Order order) async {
    await _ref.read(firebaseProvider).addOrder(order);
  }

  Future<void> updateOrder(Order order) async {
    await _ref.read(firebaseProvider).updateOrder(order);
  }

  Future<void> deleteOrder(String id) async {
    await _ref.read(firebaseProvider).deleteOrder(id);
  }
}
