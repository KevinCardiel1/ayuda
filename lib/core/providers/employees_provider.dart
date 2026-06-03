
// File: lib/core/providers/employees_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/models/employee.dart';
import 'package:floreria_ajolote/core/providers/firebase_provider.dart';

final employeesProvider = StreamProvider<List<Employee>>((ref) {
  return ref.watch(firebaseProvider).getEmployees();
});

final employeeNotifierProvider = StateNotifierProvider<EmployeeNotifier, AsyncValue<List<Employee>>>((ref) {
  return EmployeeNotifier(ref);
});

class EmployeeNotifier extends StateNotifier<AsyncValue<List<Employee>>> {
  final Ref _ref;

  EmployeeNotifier(this._ref) : super(const AsyncValue.loading()) {
    _ref.watch(firebaseProvider).getEmployees().listen((employees) {
      state = AsyncValue.data(employees);
    });
  }

  Future<void> addEmployee(Employee employee) async {
    await _ref.read(firebaseProvider).addEmployee(employee);
  }

  Future<void> updateEmployee(Employee employee) async {
    await _ref.read(firebaseProvider).updateEmployee(employee);
  }

  Future<void> deleteEmployee(String id) async {
    await _ref.read(firebaseProvider).deleteEmployee(id);
  }
}
