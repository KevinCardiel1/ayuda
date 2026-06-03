// File: lib/features/admin/profile/admin_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/providers/user_profile_provider.dart';
import 'package:floreria_ajolote/core/providers/orders_provider.dart';
import 'package:floreria_ajolote/core/providers/products_provider.dart';
import 'package:floreria_ajolote/core/state/auth_state_notifier.dart';
import 'package:floreria_ajolote/core/models/order.dart';
import 'package:floreria_ajolote/core/widgets/password_change_dialog.dart';

class AdminProfileScreen extends ConsumerWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final ordersAsync = ref.watch(orderNotifierProvider);
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      body: userProfile.when(
        data: (profile) {
          if (profile == null) {
            return const Center(
              child: Text('No se encontró el perfil.',
                  style: TextStyle(color: Color(0xFF5A4A66))),
            );
          }

          // Calculate KPIs
          double totalSales = 0;
          int activeOrders = 0;
          int lowStockCount = 0;

          ordersAsync.when(
            data: (orders) {
              for (final order in orders) {
                if (order.status == OrderStatus.delivered) {
                  totalSales += order.totalAmount;
                }
                if (order.status == OrderStatus.pending ||
                    order.status == OrderStatus.processing) {
                  activeOrders++;
                }
              }
            },
            loading: () {},
            error: (_, __) {},
          );

          productsAsync.when(
            data: (products) {
              lowStockCount = products.where((p) => p.stock < 5).length;
            },
            loading: () {},
            error: (_, __) {},
          );

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header with gradient
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2D2040), Color(0xFF4A3060)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFFFFB7C5), width: 2.5),
                        ),
                        child: CircleAvatar(
                          radius: 48,
                          backgroundColor: const Color(0xFF3D2850),
                          backgroundImage: profile.photoURL != null
                              ? NetworkImage(profile.photoURL!)
                              : null,
                          child: profile.photoURL == null
                              ? Text(
                                  profile.displayName?.isNotEmpty == true
                                      ? profile.displayName![0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    fontSize: 36,
                                    color: Color(0xFFFFB7C5),
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        profile.displayName ?? 'Administrador',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB7C5).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          profile.role.name == 'admin'
                              ? '👑 Administrador'
                              : '🛠️ Empleado',
                          style: const TextStyle(
                              color: Color(0xFFFFB7C5),
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // KPI Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _KPICard(
                          icon: Icons.attach_money_rounded,
                          label: 'Ventas\nTotales',
                          value: '\$${totalSales.toStringAsFixed(0)}',
                          color: const Color(0xFFC1FBA4),
                          iconColor: const Color(0xFF2D6A00),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _KPICard(
                          icon: Icons.pending_actions_rounded,
                          label: 'Pedidos\nActivos',
                          value: activeOrders.toString(),
                          color: const Color(0xFFB5D5FB),
                          iconColor: const Color(0xFF003C7B),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _KPICard(
                          icon: Icons.warning_amber_rounded,
                          label: 'Stock\nBajo',
                          value: lowStockCount.toString(),
                          color: lowStockCount > 0
                              ? const Color(0xFFFFAAAA)
                              : const Color(0xFFC1FBA4),
                          iconColor: lowStockCount > 0
                              ? const Color(0xFF7B0000)
                              : const Color(0xFF2D6A00),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Info section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Información Personal',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      _InfoTile(
                        icon: Icons.email_rounded,
                        label: 'Correo',
                        value: profile.email,
                      ),
                      _InfoTile(
                        icon: Icons.phone_rounded,
                        label: 'Teléfono',
                        value: profile.phoneNumber ?? 'No registrado',
                      ),
                      _InfoTile(
                        icon: Icons.badge_rounded,
                        label: 'Rol',
                        value: profile.role.name == 'admin'
                            ? 'Administrador'
                            : 'Empleado',
                      ),
                      const SizedBox(height: 20),

                      // Settings
                      Text(
                        'Configuración',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      _SettingsTile(
                        icon: Icons.lock_rounded,
                        label: 'Cambiar Contraseña',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => const PasswordChangeDialog(),
                          );
                        },
                      ),
                      _SettingsTile(
                        icon: Icons.notifications_rounded,
                        label: 'Notificaciones',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Próximamente 🌸'),
                              backgroundColor: Color(0xFFE87A9B),
                            ),
                          );
                        },
                      ),
                      _SettingsTile(
                        icon: Icons.info_outline_rounded,
                        label: 'Acerca de la App',
                        onTap: () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'Florería Ajolote',
                            applicationVersion: '1.0.0',
                            applicationIcon: const Icon(
                              Icons.local_florist_rounded,
                              size: 48,
                              color: Color(0xFFE87A9B),
                            ),
                            children: [
                              const Text(
                                'Panel de Administración para gestión de florería.',
                                style: TextStyle(color: Color(0xFF5A4A66)),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Logout button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ref
                                .read(authStateNotifierProvider.notifier)
                                .signOut();
                          },
                          icon: const Icon(Icons.logout_rounded),
                          label: const Text('Cerrar Sesión',
                              style: TextStyle(fontSize: 15)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D2040),
                            foregroundColor: const Color(0xFFFFB7C5),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
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

class _KPICard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color iconColor;

  const _KPICard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: iconColor),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: iconColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontSize: 11)),
              Text(value,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Text(label,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                    fontSize: 14)),
            const Spacer(),
            Icon(Icons.chevron_right_rounded,
                size: 20, color: Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
