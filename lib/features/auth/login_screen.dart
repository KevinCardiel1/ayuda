// File: lib/features/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:floreria_ajolote/core/widgets/axolotl_mascot.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Mascot decorator
              const AxolotlMascot(
                state: AxolotlState.idle,
                size: 150,
                message: '¡Hola! Elige tu portal de acceso 🌸',
              ),
              const SizedBox(height: 24),
              Text(
                'Florería Ajolote',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: const Color(0xFF2D2040),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Quicksand',
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Selecciona una opción para continuar',
                style: TextStyle(color: Color(0xFF5A4A66), fontSize: 15),
              ),
              const SizedBox(height: 32),

              // Portal cards
              _PortalCard(
                title: 'Soy Cliente',
                subtitle: 'Comprar flores, ver ramos y agendar eventos especiales.',
                icon: Icons.local_florist_rounded,
                gradientColors: const [Color(0xFFE87A9B), Color(0xFFFF9EC4)],
                onTap: () => context.go('/login/client'),
              ),
              const SizedBox(height: 16),
              _PortalCard(
                title: 'Soy Empleado',
                subtitle: 'Gestionar pedidos, inventario, lotes y personal.',
                icon: Icons.badge_rounded,
                gradientColors: const [Color(0xFF2D2040), Color(0xFF4A3060)],
                onTap: () => context.go('/login/employee'),
              ),
              const SizedBox(height: 32),

              TextButton(
                onPressed: () => context.go('/register'),
                child: const Text(
                  '¿No tienes una cuenta? Regístrate aquí 🌸',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE87A9B),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PortalCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _PortalCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 340),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(icon, size: 36, color: Colors.white),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Quicksand',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
