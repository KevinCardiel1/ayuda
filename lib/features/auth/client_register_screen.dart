// File: lib/features/auth/client_register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:floreria_ajolote/core/state/auth_state_notifier.dart';
import 'package:floreria_ajolote/core/widgets/axolotl_mascot.dart';

class ClientRegisterScreen extends ConsumerStatefulWidget {
  const ClientRegisterScreen({super.key});

  @override
  ConsumerState<ClientRegisterScreen> createState() => _ClientRegisterScreenState();
}

class _ClientRegisterScreenState extends ConsumerState<ClientRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            content: Text(state.message ?? 'Error de registro'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    final authState = ref.watch(authStateNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF5A4A66)),
          onPressed: () => context.go('/register'),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AxolotlMascot(
                state: AxolotlState.idle,
                size: 110,
                message: '¡Regístrate como Cliente! 🌸',
              ),
              const SizedBox(height: 12),
              const Text(
                'Registro de Cliente',
                style: TextStyle(
                  color: Color(0xFF2D2040),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                ),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _nombreController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre(s) (CLIENTE.nombre)',
                            prefixIcon: Icon(Icons.person, color: Color(0xFFE87A9B)),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Ingresa tu nombre' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _apellidoController,
                          decoration: const InputDecoration(
                            labelText: 'Apellido(s) (CLIENTE.apellido)',
                            prefixIcon: Icon(Icons.person_outline, color: Color(0xFFE87A9B)),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Ingresa tu apellido' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _telefonoController,
                          decoration: const InputDecoration(
                            labelText: 'Teléfono (CLIENTE.telefono)',
                            prefixIcon: Icon(Icons.phone, color: Color(0xFFE87A9B)),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) =>
                              value!.isEmpty ? 'Ingresa tu teléfono' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _direccionController,
                          decoration: const InputDecoration(
                            labelText: 'Dirección (CLIENTE.direccion)',
                            prefixIcon: Icon(Icons.location_on, color: Color(0xFFE87A9B)),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Ingresa tu dirección' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Correo Electrónico (CLIENTE.email)',
                            prefixIcon: Icon(Icons.email, color: Color(0xFFE87A9B)),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                              value!.isEmpty ? 'Ingresa tu correo' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Contraseña de Acceso',
                            prefixIcon: const Icon(Icons.lock, color: Color(0xFFE87A9B)),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: const Color(0xFFE87A9B)),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator: (value) =>
                              value!.isEmpty ? 'Ingresa tu contraseña' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirmar Contraseña',
                            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFE87A9B)),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, color: const Color(0xFFE87A9B)),
                              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                            ),
                          ),
                          obscureText: _obscureConfirmPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirma tu contraseña';
                            }
                            if (value != _passwordController.text) {
                              return 'Las contraseñas no coinciden';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        if (authState is AuthLoading)
                          const Center(child: CircularProgressIndicator())
                        else
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ref
                                    .read(authStateNotifierProvider.notifier)
                                    .registerClient(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      nombre: _nombreController.text,
                                      apellido: _apellidoController.text,
                                      telefono: _telefonoController.text,
                                      direccion: _direccionController.text,
                                    );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE87A9B),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('Registrarme', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/login/client'),
                child: const Text(
                  '¿Ya tienes cuenta? Inicia sesión aquí 🌸',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE87A9B),
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
