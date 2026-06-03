
// File: lib/core/widgets/occasion_form_dialog.dart
import 'package:flutter/material.dart';
import 'package:floreria_ajolote/core/models/occasion.dart';

class OccasionFormDialog extends StatefulWidget {
  final Occasion? occasion;
  final Function(Occasion) onSave;

  const OccasionFormDialog({super.key, this.occasion, required this.onSave});

  @override
  _OccasionFormDialogState createState() => _OccasionFormDialogState();
}

class _OccasionFormDialogState extends State<OccasionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late String _imageUrl;

  @override
  void initState() {
    super.initState();
    _name = widget.occasion?.name ?? '';
    _description = widget.occasion?.description ?? '';
    _imageUrl = widget.occasion?.imageUrl ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.occasion == null ? 'Add Occasion' : 'Edit Occasion'),
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
              initialValue: _description,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
              onSaved: (value) => _description = value ?? '',
            ),
            TextFormField(
              initialValue: _imageUrl,
              decoration: const InputDecoration(labelText: 'Image URL'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an image URL';
                }
                return null;
              },
              onSaved: (value) => _imageUrl = value ?? '',
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
                Occasion(
                  id: widget.occasion?.id ?? '',
                  name: _name,
                  description: _description,
                  imageUrl: _imageUrl,
                  applicableCategories: widget.occasion?.applicableCategories ?? [],
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
