// File: lib/features/admin/orders/order_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/providers/orders_provider.dart';
import 'package:floreria_ajolote/core/models/order.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends ConsumerWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderProvider(orderId));
    final notifier = ref.read(orderNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido #${orderId.length >= 8 ? orderId.substring(0, 8) : orderId}'),
        backgroundColor: const Color(0xFF2D2040),
        foregroundColor: const Color(0xFFFFB7C5),
      ),
      body: orderAsync.when(
        data: (order) {
          if (order == null) {
            return const Center(child: Text('Pedido no encontrado.'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status chip
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: _statusColor(order.status),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      _statusLabel(order.status),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Info card
                _SectionCard(
                  title: 'Información del Pedido',
                  icon: Icons.info_outline_rounded,
                  children: [
                    _InfoRow(icon: Icons.calendar_today_rounded,
                        label: 'Fecha', value: DateFormat('dd/MM/yyyy HH:mm').format(order.orderDate)),
                    _InfoRow(icon: Icons.person_rounded,
                        label: 'Cliente ID', value: order.userId),
                    if (order.shippingAddress != null)
                      _InfoRow(icon: Icons.location_on_rounded,
                          label: 'Dirección', value: order.shippingAddress!),
                    if (order.paymentMethod != null)
                      _InfoRow(icon: Icons.payment_rounded,
                          label: 'Método de Pago', value: order.paymentMethod!),
                    if (order.notes != null && order.notes!.isNotEmpty)
                      _InfoRow(icon: Icons.notes_rounded,
                          label: 'Notas', value: order.notes!),
                  ],
                ),
                const SizedBox(height: 16),

                // Items card
                _SectionCard(
                  title: 'Artículos del Pedido',
                  icon: Icons.shopping_bag_rounded,
                  children: [
                    ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Icon(Icons.local_florist_rounded,
                              size: 18, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(item.productName,
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500)),
                          ),
                          Text('x${item.quantity}',
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                          const SizedBox(width: 12),
                          Text(
                            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onSurface)),
                        Text(
                          '\$${order.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Action buttons
                Text(
                  'Cambiar Estado del Pedido',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: OrderStatus.values.map((status) {
                    final isCurrentStatus = order.status == status;
                    return ElevatedButton(
                      onPressed: isCurrentStatus
                          ? null
                          : () async {
                              final updated = order.copyWith(status: status);
                              await notifier.updateOrder(updated);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Estado actualizado a: ${_statusLabel(status)}'),
                                    backgroundColor: const Color(0xFFE87A9B),
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCurrentStatus
                            ? _statusColor(status)
                            : Theme.of(context).colorScheme.primaryContainer,
                        foregroundColor: isCurrentStatus
                            ? Colors.grey.shade900
                            : Theme.of(context).colorScheme.onSurface,
                        elevation: isCurrentStatus ? 0 : 2,
                        side: BorderSide(
                          color: isCurrentStatus
                              ? Colors.transparent
                              : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(_statusLabel(status)),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      color: Theme.of(context).cardTheme.color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text('$label: ',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface, fontSize: 13)),
          Expanded(
            child: Text(value,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8), fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
