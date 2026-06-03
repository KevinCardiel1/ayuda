// File: lib/features/client/services/client_services_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/providers/services_provider.dart';
import 'package:floreria_ajolote/core/models/service.dart';

class ClientServicesScreen extends ConsumerWidget {
  const ClientServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF0F5),
        elevation: 0,
        title: const Text(
          'Nuestros Servicios 🌺',
          style: TextStyle(
              color: Color(0xFFE87A9B), fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: servicesAsync.when(
        data: (services) {
          if (services.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.spa_rounded, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text('No hay servicios disponibles por ahora',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 15)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: services.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _ServicesBanner();
              }
              final service = services[index - 1];
              return _ServiceCard(service: service);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _ServicesBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE87A9B), Color(0xFFFF9EC4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '🌸 Servicios Especiales',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Bodas, XV años, eventos corporativos y más.\nHaz tu evento único e inolvidable.',
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),
          SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.phone_rounded, color: Colors.white, size: 16),
              SizedBox(width: 6),
              Text('Llámanos para cotizar',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final Service service;
  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 3,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          if (service.imageUrl != null && service.imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: Image.network(
                service.imageUrl!,
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 160,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFD6E0), Color(0xFFFFB7C5)],
                    ),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                  ),
                  child: const Center(
                      child: Icon(Icons.spa_rounded,
                          color: Color(0xFFE87A9B), size: 48)),
                ),
              ),
            )
          else
            Container(
              height: 130,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFD6E0), Color(0xFFFFB7C5)],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: const Center(
                  child:
                      Icon(Icons.spa_rounded, color: Color(0xFFE87A9B), size: 48)),
            ),
          // Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: const TextStyle(
                      color: Color(0xFF5A4A66),
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
                const SizedBox(height: 6),
                Text(
                  service.description,
                  style: const TextStyle(color: Color(0xFF5A4A66), fontSize: 13, height: 1.4),
                ),
                if (service.price != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Desde \$${service.price!.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Color(0xFFE87A9B),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  '📞 Por favor contáctanos para cotizar este servicio'),
                              backgroundColor: Color(0xFFE87A9B),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE87A9B),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: const Text('Cotizar', style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
