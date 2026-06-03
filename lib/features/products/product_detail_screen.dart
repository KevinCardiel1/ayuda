// File: lib/features/products/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Placeholder for ProductDetailScreen
class ProductDetailScreen extends ConsumerWidget {
  final String productId; // Example: ID of the product to display

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details: $productId'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Details for product ID: $productId'),
            // TODO: Fetch and display product details from Firestore
          ],
        ),
      ),
    );
  }
}
