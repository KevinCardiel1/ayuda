// File: lib/features/admin/employees/admin_employees_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/providers/employees_provider.dart';
import 'package:floreria_ajolote/core/models/employee.dart';

class AdminEmployeesScreen extends ConsumerWidget {
  const AdminEmployeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeesAsync = ref.watch(employeesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal'),
        backgroundColor: const Color(0xFF2D2040),
        foregroundColor: const Color(0xFFFFB7C5),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_rounded, size: 26),
            onPressed: () => _showEmployeeDialog(context, ref, null),
          ),
        ],
      ),
      body: employeesAsync.when(
        data: (employees) {
          if (employees.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group_rounded, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text('Sin personal registrado',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 15)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index];
              return _EmployeeCard(
                employee: employee,
                onEdit: () => _showEmployeeDialog(context, ref, employee),
                onDelete: () => _confirmDelete(context, ref, employee),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _showEmployeeDialog(BuildContext context, WidgetRef ref, Employee? employee) {
    final nameController = TextEditingController(text: employee?.name ?? '');
    final emailController = TextEditingController(text: employee?.email ?? '');
    String selectedRole = employee?.role ?? 'Florista';

    final roles = ['Florista', 'Repartidor', 'Cajero', 'Gerente', 'Diseñador', 'Empleado', 'Administrador'];
    if (employee != null && !roles.contains(employee.role)) {
      roles.add(employee.role);
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            employee == null ? '👤 Agregar Empleado' : '✏️ Editar Empleado',
            style: const TextStyle(color: Color(0xFF5A4A66), fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                    prefixIcon: Icon(Icons.person_rounded, color: Color(0xFFE87A9B)),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_rounded, color: Color(0xFFE87A9B)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Rol',
                    prefixIcon: Icon(Icons.work_rounded, color: Color(0xFFE87A9B)),
                  ),
                  items: roles
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedRole = v!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar',
                  style: TextStyle(color: Color(0xFF5A4A66))),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty) return;
                if (employee == null) {
                  final newEmployee = Employee(
                    id: '',
                    name: nameController.text,
                    email: emailController.text,
                    role: selectedRole,
                  );
                  await ref.read(employeeNotifierProvider.notifier).addEmployee(newEmployee);
                } else {
                  final updatedEmployee = Employee(
                    id: employee.id,
                    name: nameController.text,
                    email: emailController.text,
                    role: selectedRole,
                  );
                  await ref.read(employeeNotifierProvider.notifier).updateEmployee(updatedEmployee);
                }
                if (context.mounted) Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE87A9B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(employee == null ? 'Agregar' : 'Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, Employee employee) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('¿Eliminar empleado?',
            style: TextStyle(color: Color(0xFF5A4A66))),
        content: Text('¿Deseas eliminar a "${employee.name}" del personal?',
            style: const TextStyle(color: Color(0xFF5A4A66))),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFAAAA),
              foregroundColor: const Color(0xFF7B0000),
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(employeeNotifierProvider.notifier).deleteEmployee(employee.id);
    }
  }
}

class _EmployeeCard extends StatelessWidget {
  final Employee employee;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EmployeeCard({
    required this.employee,
    required this.onEdit,
    required this.onDelete,
  });

  Color _roleColor(String role) {
    switch (role) {
      case 'Gerente':
        return const Color(0xFFD6B5FB);
      case 'Florista':
        return const Color(0xFFFFB7C5);
      case 'Repartidor':
        return const Color(0xFFB5D5FB);
      case 'Cajero':
        return const Color(0xFFFFE0A5);
      case 'Diseñador':
        return const Color(0xFFB5FBD5);
      default:
        return const Color(0xFFE0E0E0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      color: Theme.of(context).cardTheme.color,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFFFFD6E0),
              child: Text(
                employee.name.isNotEmpty ? employee.name[0].toUpperCase() : '?',
                style: const TextStyle(
                    color: Color(0xFFE87A9B),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  if (employee.email.isNotEmpty)
                    Text(
                      employee.email,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8), fontSize: 12),
                    ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: _roleColor(employee.role),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      employee.role,
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            // Actions
            IconButton(
              icon: Icon(Icons.edit_rounded, color: Theme.of(context).colorScheme.primary),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete_rounded, color: Theme.of(context).colorScheme.error),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
