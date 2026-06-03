// File: lib/features/admin/services/admin_services_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/models/service.dart';
import 'package:floreria_ajolote/core/providers/services_provider.dart';
import 'package:floreria_ajolote/core/widgets/service_form_dialog.dart';

class AdminServicesScreen extends ConsumerWidget {
  const AdminServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsyncValue = ref.watch(servicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Servicios'),
        backgroundColor: const Color(0xFF2D2040),
        foregroundColor: const Color(0xFFFFB7C5),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_rounded, size: 28),
            onPressed: () async {
              final newService = await showDialog<Service>(
                context: context,
                builder: (context) => ServiceFormDialog(service: null),
              );
              if (newService != null) {
                await ref
                    .read(serviceNotifierProvider.notifier)
                    .addService(newService);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Servicio agregado exitosamente'),
                      backgroundColor: Color(0xFFE87A9B),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: servicesAsyncValue.when(
        data: (services) {
          if (services.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.spa_rounded, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text(
                    'Sin servicios registrados.\n¡Agrega uno!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return _AdminServiceCard(
                service: service,
                onEdit: () async {
                  final updatedService = await showDialog<Service>(
                    context: context,
                    builder: (context) =>
                        ServiceFormDialog(service: service),
                  );
                  if (updatedService != null) {
                    await ref
                        .read(serviceNotifierProvider.notifier)
                        .updateService(updatedService);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('✅ Servicio actualizado'),
                          backgroundColor: Color(0xFFE87A9B),
                        ),
                      );
                    }
                  }
                },
                onDelete: () async {
                  final confirmDelete = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      title: const Text('¿Eliminar servicio?',
                          style: TextStyle(color: Color(0xFF5A4A66))),
                      content: Text(
                        '¿Deseas eliminar "${service.name}"?',
                        style: const TextStyle(color: Color(0xFF5A4A66)),
                      ),
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
                            backgroundColor: const Color(0xFFFFAAAA),
                            foregroundColor: const Color(0xFF7B0000),
                          ),
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  );
                  if (confirmDelete ?? false) {
                    await ref
                        .read(serviceNotifierProvider.notifier)
                        .deleteService(service.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('🗑️ Servicio eliminado'),
                          backgroundColor: Color(0xFFE87A9B),
                        ),
                      );
                    }
                  }
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _AdminServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AdminServiceCard({
    required this.service,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      color: Theme.of(context).cardTheme.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image header
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
            child: (service.imageUrl != null && service.imageUrl!.isNotEmpty)
                ? Image.network(
                    service.imageUrl!,
                    width: double.infinity,
                    height: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imagePlaceholder(),
                  )
                : _imagePlaceholder(),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        service.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    // Actions
                    IconButton(
                      icon: Icon(Icons.edit_rounded,
                          color: Theme.of(context).colorScheme.primary, size: 20),
                      onPressed: onEdit,
                      visualDensity: VisualDensity.compact,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_rounded,
                          color: Theme.of(context).colorScheme.error, size: 20),
                      onPressed: onDelete,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  service.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Desde \$${service.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
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

  Widget _imagePlaceholder() {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFD6E0), Color(0xFFFFB7C5)],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: const Center(
        child: Icon(Icons.spa_rounded, color: Color(0xFFE87A9B), size: 48),
      ),
    );
  }
}
