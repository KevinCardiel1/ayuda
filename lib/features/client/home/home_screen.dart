// File: lib/features/client/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/providers/products_provider.dart';
import 'package:floreria_ajolote/core/models/product.dart';
import 'package:floreria_ajolote/core/widgets/product_card.dart'; // Assuming ProductCard widget exists

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch featured products when the screen loads
    // We might want to fetch all products or just featured ones depending on requirements
    Future.microtask(() => ref.read(productsProvider.notifier).fetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    final productsAsyncValue = ref.watch(productsProvider);
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Floreria Ajolote'),
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // TODO: Navigate to Cart Screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Shopping Cart not implemented yet.')),
              );
            },
          ),
        ],
      ),
      body: productsAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (products) {
          // Filter for featured products
          final featuredProducts = products.where((p) => p.isFeatured).toList();

          if (featuredProducts.isEmpty && products.isNotEmpty) {
            // If no featured products, show all products
            return _buildProductList(products);
          } else if (featuredProducts.isEmpty && products.isEmpty) {
            return const Center(child: Text('No products available.'));
          } else {
            // Show featured products section and then potentially all products
            return _buildFeaturedSection(context, featuredProducts, products);
          }
        },
      ),
      // Floating action button for quick access or navigation - optional
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     // TODO: Navigate to a specific category or search
      //   },
      //   label: const Text('Explore'),
      //   icon: const Icon(Icons.explore),
      // ),
    );
  }

  Widget _buildFeaturedSection(BuildContext context,
      List<Product> featuredProducts, List<Product> allProducts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Featured Picks',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height:
              250, // Height for the horizontal scrollable list of featured products
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: featuredProducts.length,
            itemBuilder: (context, index) {
              final product = featuredProducts[index];
              return ProductCard(
                product: product,
                onTap: () {
                  // TODO: Navigate to product detail screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('View details for ${product.name}')),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'All Products',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: _buildProductList(allProducts),
        ),
      ],
    );
  }

  Widget _buildProductList(List<Product> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.75, // Adjust aspect ratio as needed
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () {
            // TODO: Navigate to product detail screen
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('View details for ${product.name}')),
            );
          },
        );
      },
    );
  }
}

// Dummy ProductCard for demonstration. Replace with your actual widget.
// Ensure this widget is defined elsewhere (e.g., lib/core/widgets/product_card.dart)
// class ProductCard extends StatelessWidget {
//   final Product product;
//   final VoidCallback onTap;

//   const ProductCard({super.key, required this.product, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         clipBehavior: Clip.antiAlias,
//         elevation: 2.0,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Image.network(
//                 product.imageUrl,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image)),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product.name,
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4.0),
//                   Text(
//                     '\$${product.price.toStringAsFixed(2)}',
//                     style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
//                   ),
//                   if (product.isFeatured)
//                     const Padding(
//                       padding: EdgeInsets.only(top: 4.0),
//                       child: Icon(Icons.star, color: Colors.amber, size: 16),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
