// File: lib/core/widgets/service_card.dart
import 'package:flutter/material.dart';
import 'package:floreria_ajolote/core/models/service.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback onTap;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      clipBehavior: Clip.antiAlias,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Rounded corners
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // Service Image / Icon placeholder
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withOpacity(0.5),
              ),
              child: service.imageUrl != null && service.imageUrl!.isNotEmpty
                  ? Image.network(
                      service.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.design_services,
                          size: 40,
                          color: colorScheme.primary,
                        ),
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.design_services,
                        size: 40,
                        color: colorScheme.primary,
                      ),
                    ),
            ),
            // Service Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5A4A66),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service.description,
                      style: textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF8B7A99),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${service.price.toStringAsFixed(2)}',
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(
                Icons.chevron_right,
                color: Color(0xFF8B7A99),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
