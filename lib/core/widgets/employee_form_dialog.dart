
// File: lib/core/widgets/employee_form_dialog.dart
import 'package:flutter/material.dart';
import 'package:floreria_ajolote/core/models/employee.dart';

class EmployeeFormDialog extends StatefulWidget {
  final Employee? employee;
  final Function(Employee) onSave;

  const EmployeeFormDialog({super.key, this.employee, required this.onSave});

  @override
  _EmployeeFormDialogState createState() => _EmployeeFormDialogState();
}

class _EmployeeFormDialogState extends State<EmployeeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _role;

  @override
  void initState() {
    super.initState();
    _name = widget.employee?.name ?? '';
    _role = widget.employee?.role ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.employee == null ? 'Add Employee' : 'Edit Employee'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _name,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (value) => _name = value ?? '',
            ),
            TextFormField(
              initialValue: _role,
              decoration: const InputDecoration(labelText: 'Role'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a role';
                }
                return null;
              },
              onSaved: (value) => _role = value ?? '',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              widget.onSave(
                Employee(
                  id: widget.employee?.id ?? '', // Keep original ID or let backend generate one
                  name: _name,
                  role: _role,
                ),
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
