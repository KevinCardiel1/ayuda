// File: lib/features/auth/employee_register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:floreria_ajolote/core/state/auth_state_notifier.dart';
import 'package:floreria_ajolote/core/widgets/axolotl_mascot.dart';
import 'package:floreria_ajolote/core/theme/theme_provider.dart';

class EmployeeRegisterScreen extends ConsumerStatefulWidget {
  const EmployeeRegisterScreen({super.key});

  @override
  ConsumerState<EmployeeRegisterScreen> createState() => _EmployeeRegisterScreenState();
}

class _EmployeeRegisterScreenState extends ConsumerState<EmployeeRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedRole = 'Florista';
  String _selectedShift = 'Matutino';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
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

    return Theme(
      data: ref.watch(employeeThemeProvider),
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFFFFB7C5)),
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
                message: '¡Registro de Personal! 🛠️',
              ),
              const SizedBox(height: 12),
              const Text(
                'Registro de Empleado',
                style: TextStyle(
                  color: Color(0xFFFFB7C5),
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
                elevation: 6,
                color: const Color(0xFF3D2850),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _nombreController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF2D2040),
                            labelText: 'Nombre Completo (EMPLEADO.nombre)',
                            labelStyle: TextStyle(color: Color(0xFFFFB7C5)),
                            prefixIcon: Icon(Icons.person, color: Color(0xFFFFB7C5)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFB7C5)),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Ingresa tu nombre' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _telefonoController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF2D2040),
                            labelText: 'Teléfono (EMPLEADO.telefono)',
                            labelStyle: TextStyle(color: Color(0xFFFFB7C5)),
                            prefixIcon: Icon(Icons.phone, color: Color(0xFFFFB7C5)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFB7C5)),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) =>
                              value!.isEmpty ? 'Ingresa tu teléfono' : null,
                        ),
                        const SizedBox(height: 12),
                        // Role Dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedRole,
                          dropdownColor: const Color(0xFF3D2850),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF2D2040),
                            labelText: 'Puesto / Rol (EMPLEADO.rol)',
                            labelStyle: TextStyle(color: Color(0xFFFFB7C5)),
                            prefixIcon: Icon(Icons.work_rounded, color: Color(0xFFFFB7C5)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFB7C5)),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Florista', child: Text('Florista 🌸')),
                            DropdownMenuItem(value: 'Repartidor', child: Text('Repartidor 🚴')),
                            DropdownMenuItem(value: 'Cajero', child: Text('Cajero 💵')),
                            DropdownMenuItem(value: 'Administrador', child: Text('Administrador 👑')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedRole = val;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        // Shift Dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedShift,
                          dropdownColor: const Color(0xFF3D2850),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF2D2040),
                            labelText: 'Turno de Trabajo (EMPLEADO.turno)',
                            labelStyle: TextStyle(color: Color(0xFFFFB7C5)),
                            prefixIcon: Icon(Icons.schedule_rounded, color: Color(0xFFFFB7C5)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFB7C5)),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Matutino', child: Text('Matutino (6 AM - 2 PM)')),
                            DropdownMenuItem(value: 'Vespertino', child: Text('Vespertino (2 PM - 10 PM)')),
                            DropdownMenuItem(value: 'Nocturno', child: Text('Nocturno (10 PM - 6 AM)')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedShift = val;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF2D2040),
                            labelText: 'Correo Institucional (EMPLEADO.email)',
                            labelStyle: TextStyle(color: Color(0xFFFFB7C5)),
                            prefixIcon: Icon(Icons.email, color: Color(0xFFFFB7C5)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFB7C5)),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                              value!.isEmpty ? 'Ingresa tu correo' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF2D2040),
                            labelText: 'Contraseña de Personal',
                            labelStyle: const TextStyle(color: Color(0xFFFFB7C5)),
                            prefixIcon: const Icon(Icons.lock, color: Color(0xFFFFB7C5)),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: const Color(0xFFFFB7C5)),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFB7C5)),
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator: (value) =>
                              value!.isEmpty ? 'Ingresa tu contraseña' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _confirmPasswordController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF2D2040),
                            labelText: 'Confirmar Contraseña',
                            labelStyle: const TextStyle(color: Color(0xFFFFB7C5)),
                            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFFFB7C5)),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, color: const Color(0xFFFFB7C5)),
                              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFB7C5)),
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
                        const SizedBox(height: 24),
                        if (authState is AuthLoading)
                          const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(0xFFFFB7C5))))
                        else
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ref
                                    .read(authStateNotifierProvider.notifier)
                                    .registerEmployee(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      nombre: _nombreController.text,
                                      puestoTrabajo: _selectedRole,
                                      telefono: _telefonoController.text,
                                      turno: _selectedShift,
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
                            child: const Text('Registrar Empleado', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/login/employee'),
                child: const Text(
                  '¿Ya tienes cuenta de personal? Inicia sesión aquí 🛠️',
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
