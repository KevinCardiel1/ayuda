// File: lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/state/auth_state_notifier.dart';
import 'package:floreria_ajolote/features/auth/login_screen.dart';
import 'package:floreria_ajolote/features/auth/register_screen.dart';
import 'package:floreria_ajolote/features/splash/splash_screen.dart';
import 'package:floreria_ajolote/features/dashboard/dashboard_screen.dart';
import 'package:floreria_ajolote/features/admin/orders/order_detail_screen.dart';
import 'package:floreria_ajolote/features/client/checkout/checkout_screen.dart';

import 'package:floreria_ajolote/features/auth/client_login_screen.dart';
import 'package:floreria_ajolote/features/auth/employee_login_screen.dart';
import 'package:floreria_ajolote/features/auth/client_register_screen.dart';
import 'package:floreria_ajolote/features/auth/employee_register_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) {
          if (authState is Authenticated) {
            return DashboardScreen(userProfile: authState.userProfile!);
          } else if (authState is Unauthenticated) {
            return const LoginScreen();
          } else if (authState is AuthError) {
            return Scaffold(body: Center(child: Text(authState.message ?? 'Error')));
          } else {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
        },
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/login/client', builder: (context, state) => const ClientLoginScreen()),
      GoRoute(path: '/login/employee', builder: (context, state) => const EmployeeLoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(path: '/register/client', builder: (context, state) => const ClientRegisterScreen()),
      GoRoute(path: '/register/employee', builder: (context, state) => const EmployeeRegisterScreen()),

      // Admin Routes
      GoRoute(
        path: '/admin',
        builder: (context, state) {
          if (authState is Authenticated) {
            return DashboardScreen(userProfile: authState.userProfile!);
          }
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/admin/orders/:id',
        builder: (context, state) => OrderDetailScreen(orderId: state.pathParameters['id']!),
      ),

      // Client Routes
      GoRoute(
        path: '/client',
        builder: (context, state) {
          if (authState is Authenticated) {
            return DashboardScreen(userProfile: authState.userProfile!);
          }
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/client/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = authState is Authenticated;
      final location = state.matchedLocation;
      final isAtLogin = location.startsWith('/login') || location.startsWith('/register') || location == '/';

      if (!isAuthenticated && !isAtLogin) {
        return '/login';
      } else if (isAuthenticated && (location.startsWith('/login') || location.startsWith('/register') || location == '/')) {
        return '/dashboard';
      }
      return null;
    },
  );
});
