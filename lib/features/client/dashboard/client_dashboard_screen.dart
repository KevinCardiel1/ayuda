// File: lib/features/client/dashboard/client_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/providers/navigation_providers.dart';
import 'package:floreria_ajolote/core/models/user_profile.dart';
import 'package:floreria_ajolote/features/client/products/client_products_screen.dart';
import 'package:floreria_ajolote/features/client/services/client_services_screen.dart';
import 'package:floreria_ajolote/features/client/cart/cart_screen.dart';
import 'package:floreria_ajolote/features/client/orders/client_orders_screen.dart';
import 'package:floreria_ajolote/features/client/profile/client_profile_screen.dart';

class ClientDashboardScreen extends ConsumerWidget {
  final UserProfile userProfile;
  const ClientDashboardScreen({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(clientTabProvider);

    final List<Widget> screens = [
      const ClientProductsScreen(),
      const ClientServicesScreen(),
      const CartScreen(),
      const ClientOrdersScreen(),
      const ClientProfileScreen(),
    ];

    return Scaffold(
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
            ref.read(clientTabProvider.notifier).state = index;
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFFE87A9B),
          unselectedItemColor: const Color(0xFF5A4A66).withOpacity(0.6),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_rounded),
              activeIcon: Icon(Icons.storefront_rounded, color: Color(0xFFE87A9B)),
              label: 'Tienda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.spa_rounded),
              activeIcon: Icon(Icons.spa_rounded, color: Color(0xFFE87A9B)),
              label: 'Servicios',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket_rounded),
              activeIcon: Icon(Icons.shopping_basket_rounded, color: Color(0xFFE87A9B)),
              label: 'Carrito',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_rounded),
              activeIcon: Icon(Icons.receipt_long_rounded, color: Color(0xFFE87A9B)),
              label: 'Pedidos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              activeIcon: Icon(Icons.person_rounded, color: Color(0xFFE87A9B)),
              label: 'Mi Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
