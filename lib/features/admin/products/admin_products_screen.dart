// File: lib/features/admin/products/admin_products_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/models/product.dart';
import 'package:floreria_ajolote/core/providers/products_provider.dart';
import 'package:floreria_ajolote/core/widgets/product_form_dialog.dart';

class AdminProductsScreen extends ConsumerWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario de Productos'),
        backgroundColor: const Color(0xFF2D2040),
        foregroundColor: const Color(0xFFFFB7C5),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_rounded, size: 28),
            onPressed: () async {
              final newProduct = await showDialog<Product>(
                context: context,
                builder: (context) => const ProductFormDialog(product: null),
              );
              if (newProduct != null) {
                await ref.read(productNotifierProvider.notifier).addProduct(newProduct);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Producto agregado'),
                      backgroundColor: Color(0xFFE87A9B),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: productsAsync.when(
        data: (products) {
          final lowStock = products.where((p) => p.stock < 5 && p.stock > 0).toList();
          final outOfStock = products.where((p) => p.stock == 0).toList();
          return Column(
            children: [
              // KPI summary banner
              if (lowStock.isNotEmpty || outOfStock.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.15),
                  child: Row(
                    children: [
                      if (outOfStock.isNotEmpty)
                        _KPIChip(
                          icon: Icons.error_rounded,
                          label: '${outOfStock.length} Agotado(s)',
                          color: const Color(0xFFFFAAAA),
                          textColor: const Color(0xFF7B0000),
                        ),
                      if (outOfStock.isNotEmpty) const SizedBox(width: 8),
                      if (lowStock.isNotEmpty)
                        _KPIChip(
                          icon: Icons.warning_amber_rounded,
                          label: '${lowStock.length} Stock bajo',
                          color: const Color(0xFFFFE0A5),
                          textColor: const Color(0xFF7B4F00),
                        ),
                    ],
                  ),
                ),
              // Product list
              Expanded(
                child: products.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inventory_2_rounded,
                                size: 64, color: Colors.grey.shade300),
                            const SizedBox(height: 12),
                            Text(
                              'Sin productos. ¡Agrega uno!',
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          Color stockColor;
                          String stockLabel;
                          if (product.stock == 0) {
                            stockColor = const Color(0xFFFFAAAA);
                            stockLabel = 'Agotado';
                          } else if (product.stock < 5) {
                            stockColor = const Color(0xFFFFE0A5);
                            stockLabel = 'Stock bajo: ${product.stock}';
                          } else {
                            stockColor = const Color(0xFFC1FBA4);
                            stockLabel = 'Stock: ${product.stock}';
                          }
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            elevation: 2,
                            color: Theme.of(context).cardTheme.color,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              child: Row(
                                children: [
                                  // Product image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: product.imageUrl.isNotEmpty
                                        ? Image.network(
                                            product.imageUrl,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                _PlaceholderImage(),
                                          )
                                        : _PlaceholderImage(),
                                  ),
                                  const SizedBox(width: 12),
                                  // Product info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Theme.of(context).colorScheme.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '\$${product.price.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: stockColor,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            stockLabel,
                                            style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Actions
                                  Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit_rounded,
                                            color: Theme.of(context).colorScheme.primary, size: 20),
                                        onPressed: () async {
                                          final updated = await showDialog<Product>(
                                            context: context,
                                            builder: (context) =>
                                                ProductFormDialog(product: product),
                                          );
                                          if (updated != null) {
                                            await ref
                                                .read(productNotifierProvider.notifier)
                                                .updateProduct(updated);
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete_rounded,
                                            color: Theme.of(context).colorScheme.error, size: 20),
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16)),
                                              title: const Text('¿Eliminar producto?'),
                                              content: Text(
                                                  '¿Seguro que deseas eliminar "${product.name}"?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context).pop(false),
                                                  child: const Text('Cancelar'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      Navigator.of(context).pop(true),
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          const Color(0xFFFFAAAA)),
                                                  child: const Text('Eliminar',
                                                      style: TextStyle(
                                                          color: Color(0xFF7B0000))),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirm == true) {
                                            await ref
                                                .read(productNotifierProvider.notifier)
                                                .deleteProduct(product.id);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _KPIChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color textColor;

  const _KPIChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: textColor, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      color: const Color(0xFFFFD6E0),
      child: const Icon(Icons.local_florist_rounded, color: Color(0xFFE87A9B), size: 30),
    );
  }
}
