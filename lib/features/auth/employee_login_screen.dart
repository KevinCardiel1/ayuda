// File: lib/features/auth/employee_login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:floreria_ajolote/core/state/auth_state_notifier.dart';
import 'package:floreria_ajolote/core/models/user_profile.dart';
import 'package:floreria_ajolote/core/widgets/axolotl_mascot.dart';
import 'package:floreria_ajolote/core/theme/theme_provider.dart';

class EmployeeLoginScreen extends ConsumerStatefulWidget {
  const EmployeeLoginScreen({super.key});

  @override
  ConsumerState<EmployeeLoginScreen> createState() => _EmployeeLoginScreenState();
}

class _EmployeeLoginScreenState extends ConsumerState<EmployeeLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authStateNotifierProvider, (_, state) {
      if (state is Authenticated) {
        context.go('/dashboard');
      } else if (state is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message ?? 'Error de autenticación'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    final authState = ref.watch(authStateNotifierProvider);

    return Theme(
      data: ref.watch(employeeThemeProvider),
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFFFFB7C5)),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AxolotlMascot(
                state: AxolotlState.idle,
                size: 130,
                message: 'Portal de Empleados 🛠️',
              ),
              const SizedBox(height: 16),
              const Text(
                'Acceso Administrativo',
                style: TextStyle(
                  color: Color(0xFFFFB7C5),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ingresa para gestionar pedidos, inventario y personal',
                style: TextStyle(color: Color(0xFFFFF0F5), fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 6,
                color: const Color(0xFF3D2850), // Dark surface
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF2D2040),
                            labelText: 'Correo Institucional',
                            labelStyle: TextStyle(color: Color(0xFFFFB7C5)),
                            prefixIcon: Icon(Icons.badge_rounded, color: Color(0xFFFFB7C5)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFB7C5)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                              value!.isEmpty ? 'Ingresa tu correo' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF2D2040),
                            labelText: 'Contraseña',
                            labelStyle: const TextStyle(color: Color(0xFFFFB7C5)),
                            prefixIcon: const Icon(Icons.lock_rounded, color: Color(0xFFFFB7C5)),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: const Color(0xFFFFB7C5)),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFB7C5)),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator: (value) =>
                              value!.isEmpty ? 'Ingresa tu contraseña' : null,
                        ),
                        const SizedBox(height: 28),
                        if (authState is AuthLoading)
                          const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(0xFFFFB7C5))))
                        else
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ref
                                    .read(authStateNotifierProvider.notifier)
                                    .signInWithEmailAndPasswordAndRole(
                                      _emailController.text,
                                      _passwordController.text,
                                      [UserRole.employee, UserRole.admin],
                                    );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFB7C5),
                              foregroundColor: const Color(0xFF2D2040),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('Ingresar al Sistema', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => context.go('/register/employee'),
                child: const Text(
                  '¿No tienes cuenta de personal? Regístrate aquí 🛠️',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFB7C5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
