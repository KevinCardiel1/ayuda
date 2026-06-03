// File: lib/features/admin/dashboard/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/models/user_profile.dart';
import 'package:floreria_ajolote/core/providers/navigation_providers.dart';
import 'package:floreria_ajolote/features/admin/orders/admin_orders_screen.dart';
import 'package:floreria_ajolote/features/admin/products/admin_products_screen.dart';
import 'package:floreria_ajolote/features/admin/services/admin_services_screen.dart';
import 'package:floreria_ajolote/features/admin/employees/admin_employees_screen.dart';
import 'package:floreria_ajolote/features/admin/profile/admin_profile_screen.dart';
import 'package:floreria_ajolote/core/theme/theme_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  final UserProfile userProfile;
  const AdminDashboardScreen({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(adminTabProvider);

    final List<Widget> screens = [
      const AdminOrdersScreen(),
      const AdminProductsScreen(),
      const AdminServicesScreen(),
      const AdminEmployeesScreen(),
      const AdminProfileScreen(),
    ];

    return Theme(
      data: ref.watch(employeeThemeProvider),
      child: Scaffold(

      body: IndexedStack(
        index: currentTab,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentTab,
          onTap: (index) {
            ref.read(adminTabProvider.notifier).state = index;
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF2D2040),
          selectedItemColor: const Color(0xFFFFB7C5),
          unselectedItemColor: const Color(0xFFFFB7C5).withOpacity(0.45),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_rounded),
              activeIcon: Icon(Icons.list_alt_rounded, color: Color(0xFFFFB7C5)),
              label: 'Pedidos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_rounded),
              activeIcon: Icon(Icons.inventory_2_rounded, color: Color(0xFFFFB7C5)),
              label: 'Inventario',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.spa_rounded),
              activeIcon: Icon(Icons.spa_rounded, color: Color(0xFFFFB7C5)),
              label: 'Servicios',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_rounded),
              activeIcon: Icon(Icons.group_rounded, color: Color(0xFFFFB7C5)),
              label: 'Personal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts_rounded),
              activeIcon: Icon(Icons.manage_accounts_rounded, color: Color(0xFFFFB7C5)),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    ),
    );
  }
}
