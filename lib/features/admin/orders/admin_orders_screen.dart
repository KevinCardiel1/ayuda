// File: lib/features/admin/orders/admin_orders_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:floreria_ajolote/core/providers/orders_provider.dart';
import 'package:floreria_ajolote/core/models/order.dart';
import 'package:intl/intl.dart';

class AdminOrdersScreen extends ConsumerStatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  ConsumerState<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends ConsumerState<AdminOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

  Color _statusTextColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFF7B4F00);
      case OrderStatus.processing:
        return const Color(0xFF003C7B);
      case OrderStatus.shipped:
        return const Color(0xFF005C31);
      case OrderStatus.delivered:
        return const Color(0xFF2D6A00);
      case OrderStatus.cancelled:
        return const Color(0xFF7B0000);
      default:
        return Colors.black87;
    }
  }

  String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pendiente';
      case OrderStatus.processing:
        return 'En proceso';
      case OrderStatus.shipped:
        return 'En camino';
      case OrderStatus.delivered:
        return 'Entregado';
      case OrderStatus.cancelled:
        return 'Cancelado';
      default:
        return status.name;
    }
  }

  Widget _buildOrderList(List<Order> orders, OrderStatus filter) {
    final filtered = orders.where((o) => o.status == filter).toList();
    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_rounded, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'Sin pedidos ${_statusLabel(filter).toLowerCase()}s',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final order = filtered[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 2,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => context.go('/admin/orders/${order.id}'),
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusColor(order.status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _statusLabel(order.status),
                          style: TextStyle(
                            color: _statusTextColor(order.status),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(order.orderDate),
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8), fontSize: 13),
                      ),
                      const Spacer(),
                      Text(
                        '\$${order.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.shopping_bag_outlined, size: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Text(
                        '${order.items.length} artículo(s)',
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8), fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(orderNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Pedidos'),
        backgroundColor: const Color(0xFF2D2040),
        foregroundColor: const Color(0xFFFFB7C5),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFFFB7C5),
          labelColor: const Color(0xFFFFB7C5),
          unselectedLabelColor: const Color(0xFFFFB7C5).withOpacity(0.5),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          tabs: const [
            Tab(text: 'Pendiente'),
            Tab(text: 'En proceso'),
            Tab(text: 'En camino'),
            Tab(text: 'Entregados'),
          ],
        ),
      ),
      body: ordersAsync.when(
        data: (orders) => TabBarView(
          controller: _tabController,
          children: [
            _buildOrderList(orders, OrderStatus.pending),
            _buildOrderList(orders, OrderStatus.processing),
            _buildOrderList(orders, OrderStatus.shipped),
            _buildOrderList(orders, OrderStatus.delivered),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
