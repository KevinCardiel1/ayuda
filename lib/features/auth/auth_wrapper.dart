
// File: lib/features/auth/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/state/auth_state_notifier.dart';
import 'package:floreria_ajolote/features/auth/login_screen.dart';
import 'package:floreria_ajolote/features/dashboard/dashboard_screen.dart';
import 'package:floreria_ajolote/features/splash/splash_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateNotifierProvider);

    return authState.when(
      initial: () => const SplashScreen(),
      authenticated: (user, userProfile) {
        if (userProfile == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return DashboardScreen(userProfile: userProfile);
      },
      unauthenticated: () => const LoginScreen(),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (message) => Scaffold(
        body: Center(
          child: Text('Error: $message'),
        ),
      ),
    );
  }
}
