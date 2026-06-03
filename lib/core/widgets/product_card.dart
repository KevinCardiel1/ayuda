// File: lib/core/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:floreria_ajolote/core/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias, // Clip content to the card's shape
        elevation: 3.0, // Add a subtle shadow for depth
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover, // Cover the available space
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: colorScheme.surface, // Placeholder background color
                      child: const Center(
                        child: Icon(Icons.broken_image,
                            size: 40, color: Colors.grey),
                      ),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child; // Image loaded
                      return Container(
                        color: colorScheme.surface.withOpacity(0.5),
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            color: colorScheme.primary,
                          ),
                        ),
                      );
                    },
                  ),
                  // Featured badge
                  if (product.isFeatured)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              Colors.amber.shade700, // Amber color for featured
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Featured',
                              style: (textTheme.bodySmall ?? const TextStyle()).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Product Details
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: (textTheme.titleMedium ?? const TextStyle())
                        .copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  // Product Price
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: (textTheme.bodyLarge ?? const TextStyle()).copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary, // Use primary color for price
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  // Stock indicator (optional)
                  // Text(
                  //   'Stock: ${product.stock}',
                  //   style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
