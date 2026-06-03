// File: lib/features/client/products/client_products_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:floreria_ajolote/core/providers/products_provider.dart';
import 'package:floreria_ajolote/core/providers/cart_provider.dart';
import 'package:floreria_ajolote/core/providers/user_profile_provider.dart';
import 'package:floreria_ajolote/core/providers/orders_provider.dart';
import 'package:floreria_ajolote/core/models/product.dart';
import 'package:floreria_ajolote/core/models/order.dart';

class ClientProductsScreen extends ConsumerStatefulWidget {
  const ClientProductsScreen({super.key});

  @override
  ConsumerState<ClientProductsScreen> createState() => _ClientProductsScreenState();
}

class _ClientProductsScreenState extends ConsumerState<ClientProductsScreen> {
  String _searchQuery = '';
  String? _selectedCategory;

  final List<String> _categories = [
    'Todos',
    'Ramos',
    'Arreglos',
    'Coronas',
    'Eventos',
    'Especiales',
  ];

  void _buyNow(Product product) async {
    final userProfileAsync = ref.read(userProfileProvider);
    userProfileAsync.when(
      data: (profile) async {
        if (profile == null) return;

        final order = Order(
          userId: profile.uid,
          items: [
            OrderItem(
              productId: product.id,
              productName: product.name,
              quantity: 1,
              price: product.price,
              imageUrl: product.imageUrl,
            ),
          ],
          orderDate: DateTime.now(),
          totalAmount: product.price,
          status: OrderStatus.pending,
          paymentStatus: PaymentStatus.pending,
          shippingAddress: profile.direccion ?? '',
          paymentMethod: 'Tarjeta',
        );

        await ref.read(orderNotifierProvider.notifier).addOrder(order);

        if (mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('¡Compra Exitosa! 🎉',
                  style: TextStyle(color: Color(0xFF2D2040), fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_rounded, color: Color(0xFFE87A9B), size: 64),
                  const SizedBox(height: 12),
                  Text('Has comprado "${product.name}"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF5A4A66))),
                  const SizedBox(height: 4),
                  Text('Total: \$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: Color(0xFFE87A9B), fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  const Text('¡Gracias por tu compra! 🌸',
                      style: TextStyle(color: Color(0xFF5A4A66), fontSize: 13)),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE87A9B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Aceptar'),
                ),
              ],
            ),
          );
        }
      },
      loading: () {},
      error: (e, _) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF0F5),
        elevation: 0,
        title: const Text(
          'Florería Ajolote 🌸',
          style: TextStyle(
            color: Color(0xFFE87A9B),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar flores, ramos...',
                hintStyle: const TextStyle(color: Color(0xFF5A4A66), fontSize: 14),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFE87A9B)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
            ),
          ),
          // Category chips
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected =
                    (cat == 'Todos' && _selectedCategory == null) ||
                        _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = (cat == 'Todos') ? null : cat;
                    });
                  },
                  selectedColor: const Color(0xFFE87A9B),
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF5A4A66),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFFE87A9B)
                          : const Color(0xFFFFD6E0),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Product grid
          Expanded(
            child: productsAsync.when(
              data: (products) {
                final filtered = products.where((p) {
                  final matchesSearch = _searchQuery.isEmpty ||
                      p.name.toLowerCase().contains(_searchQuery) ||
                      p.description.toLowerCase().contains(_searchQuery);
                  final matchesCategory = _selectedCategory == null ||
                      p.categories.contains(_selectedCategory);
                  return matchesSearch && matchesCategory;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_florist_rounded,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text(
                          'No encontramos flores con ese filtro',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 80),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.55,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final product = filtered[index];
                    return _ProductCard(
                      product: product,
                      onAddToCart: () {
                        cartNotifier.addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} agregado al carrito 🛒'),
                            backgroundColor: const Color(0xFFE87A9B),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      onBuyNow: () => _buyNow(product),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const _ProductCard({required this.product, required this.onAddToCart, required this.onBuyNow});

  @override
  Widget build(BuildContext context) {
    final bool outOfStock = product.stock == 0;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: product.imageUrl.isNotEmpty
                      ? Image.network(
                          product.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _imageError(),
                        )
                      : _imageError(),
                ),
                if (product.isFeatured)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE87A9B),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('⭐ Destacado',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                if (outOfStock)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: const Center(
                        child: Text('Agotado',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14))),
                  ),
              ],
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 2),
            child: Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Color(0xFF5A4A66),
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            ),
          ),
          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              product.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Color(0xFF5A4A66),
                  fontSize: 11,
                  height: 1.3),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
            child: Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                  color: Color(0xFFE87A9B), fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          // Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 2, 6, 6),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      onPressed: outOfStock ? null : onAddToCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE87A9B),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        outOfStock ? 'Agotado' : '🛒 Agregar',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: SizedBox(
                    height: 32,
                    child: OutlinedButton(
                      onPressed: outOfStock ? null : onBuyNow,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFE87A9B),
                        side: const BorderSide(color: Color(0xFFE87A9B)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Comprar',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageError() {
    return Container(
      color: const Color(0xFFFFD6E0),
      child: const Center(
          child: Icon(Icons.local_florist_rounded,
              color: Color(0xFFE87A9B), size: 48)),
    );
  }
}
