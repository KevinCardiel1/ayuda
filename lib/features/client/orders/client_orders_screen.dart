// File: lib/features/client/orders/client_orders_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/providers/orders_provider.dart';
import 'package:floreria_ajolote/core/models/order.dart';
import 'package:floreria_ajolote/core/widgets/axolotl_mascot.dart';
import 'package:floreria_ajolote/core/providers/user_profile_provider.dart';
import 'package:intl/intl.dart';

class ClientOrdersScreen extends ConsumerWidget {
  const ClientOrdersScreen({super.key});

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFFFFD6A5);
      case OrderStatus.processing:
        return const Color(0xFFB5D5FB);
      case OrderStatus.shipped:
        return const Color(0xFFB5FBD5);
      case OrderStatus.delivered:
        return const Color(0xFFC1FBA4);
      case OrderStatus.cancelled:
        return const Color(0xFFFFAAAA);
      default:
        return const Color(0xFFE0E0E0);
    }
  }

  String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return '⏳ Pendiente';
      case OrderStatus.processing:
        return '🔧 En proceso';
      case OrderStatus.shipped:
        return '🚚 En camino';
      case OrderStatus.delivered:
        return '✅ Entregado';
      case OrderStatus.cancelled:
        return '❌ Cancelado';
      default:
        return status.name;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);
    final userProfileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF0F5),
        elevation: 0,
        title: const Text(
          'Mis Pedidos 🌸',
          style: TextStyle(color: Color(0xFFE87A9B), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ordersAsync.when(
        data: (allOrders) {
          // Filter orders for the current user
          final uid = userProfileAsync.when(
            data: (p) => p?.uid,
            loading: () => null,
            error: (_, __) => null,
          );

          final orders = uid != null
              ? allOrders.where((o) => o.userId == uid).toList()
              : allOrders;

          // Sort newest first
          orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  AxolotlMascot(
                    state: AxolotlState.empty,
                    size: 150,
                    message: 'Aún no tienes pedidos 🌸\n¡Empieza a comprar!',
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pedido #${order.id?.substring(0, 8) ?? '—'}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5A4A66),
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _statusColor(order.status),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _statusLabel(order.status),
                              style: const TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat('dd/MM/yyyy  HH:mm').format(order.orderDate),
                        style: const TextStyle(
                            color: Color(0xFF5A4A66), fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      // Items preview
                      ...order.items.take(2).map((item) => Text(
                            '• ${item.productName} x${item.quantity}',
                            style: const TextStyle(
                                color: Color(0xFF5A4A66), fontSize: 12),
                          )),
                      if (order.items.length > 2)
                        Text(
                          '  + ${order.items.length - 2} más...',
                          style: const TextStyle(
                              color: Color(0xFFE87A9B), fontSize: 12),
                        ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (order.paymentMethod != null)
                            Row(
                              children: [
                                const Icon(Icons.payment_rounded,
                                    size: 14, color: Color(0xFF5A4A66)),
                                const SizedBox(width: 4),
                                Text(
                                  order.paymentMethod!,
                                  style: const TextStyle(
                                      color: Color(0xFF5A4A66), fontSize: 12),
                                ),
                              ],
                            ),
                          Text(
                            '\$${order.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Color(0xFFE87A9B),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}