
// File: lib/features/splash/splash_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:floreria_ajolote/core/state/auth_state_notifier.dart';
import 'package:floreria_ajolote/core/widgets/axolotl_mascot.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      final authState = ref.read(authStateNotifierProvider);
      authState.when(
        initial: () {},
        loading: () {},
        authenticated: (_, userProfile) {
          if (userProfile != null) {
            // Navigate based on role
            if (userProfile.role.name == 'admin' || userProfile.role.name == 'employee') {
              context.go('/admin');
            } else {
              context.go('/client');
            }
          } else {
            context.go('/login'); // Fallback if profile is somehow null
          }
        },
        unauthenticated: () => context.go('/login'),
        error: (_) => context.go('/login'), // On error, go to login
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AxolotlMascot(
              state: AxolotlState.idle,
              size: 200,
              message: 'Cargando dulzura floral...',
            ),
            const SizedBox(height: 20),
            Text(
              'Florería Ajolote',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

