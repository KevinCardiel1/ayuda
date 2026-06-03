// File: lib/core/widgets/product_form_dialog.dart
import 'package:flutter/material.dart';
import 'package:floreria_ajolote/core/models/product.dart';

class ProductFormDialog extends StatefulWidget {
  final Product? product;

  const ProductFormDialog({super.key, this.product});

  @override
  ProductFormDialogState createState() => ProductFormDialogState();
}

class ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late double _price;
  late String _imageUrl;
  late int _stock;
  late bool _isFeatured;
  late List<String> _selectedCategories;

  static const List<String> _availableCategories = [
    'Ramos',
    'Arreglos',
    'Coronas',
    'Eventos',
    'Especiales',
  ];

  @override
  void initState() {
    super.initState();
    _name = widget.product?.name ?? '';
    _description = widget.product?.description ?? '';
    _price = widget.product?.price ?? 0.0;
    _imageUrl = widget.product?.imageUrl ?? '';
    _stock = widget.product?.stock ?? 0;
    _isFeatured = widget.product?.isFeatured ?? false;
    _selectedCategories = List<String>.from(widget.product?.categories ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        widget.product == null ? 'Agregar Producto' : 'Editar Producto',
        style: const TextStyle(color: Color(0xFF2D2040), fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _name,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del Producto',
                    prefixIcon: Icon(Icons.local_florist_rounded, color: Color(0xFFE87A9B)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa el nombre del producto';
                    }
                    return null;
                  },
                  onSaved: (value) => _name = value ?? '',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: _description,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    prefixIcon: Icon(Icons.description_rounded, color: Color(0xFFE87A9B)),
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa una descripción';
                    }
                    return null;
                  },
                  onSaved: (value) => _description = value ?? '',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: _price == 0.0 ? '' : _price.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Precio (\$)',
                    prefixIcon: Icon(Icons.attach_money_rounded, color: Color(0xFFE87A9B)),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty || double.tryParse(value) == null) {
                      return 'Ingresa un precio válido';
                    }
                    return null;
                  },
                  onSaved: (value) => _price = double.tryParse(value ?? '0.0') ?? 0.0,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: _imageUrl,
                  decoration: const InputDecoration(
                    labelText: 'URL de la Imagen',
                    prefixIcon: Icon(Icons.image_rounded, color: Color(0xFFE87A9B)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa la URL de la imagen';
                    }
                    return null;
                  },
                  onSaved: (value) => _imageUrl = value ?? '',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: _stock == 0 ? '' : _stock.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Stock (unidades)',
                    prefixIcon: Icon(Icons.inventory_rounded, color: Color(0xFFE87A9B)),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty || int.tryParse(value) == null) {
                      return 'Ingresa una cantidad válida';
                    }
                    return null;
                  },
                  onSaved: (value) => _stock = int.tryParse(value ?? '0') ?? 0,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Categorías',
                  style: TextStyle(
                    color: Color(0xFF5A4A66),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _availableCategories.map((cat) {
                    final isSelected = _selectedCategories.contains(cat);
                    return FilterChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedCategories.add(cat);
                          } else {
                            _selectedCategories.remove(cat);
                          }
                        });
                      },
                      selectedColor: const Color(0xFFE87A9B),
                      backgroundColor: const Color(0xFFFFF0F5),
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF5A4A66),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFFE87A9B) : const Color(0xFFFFD6E0),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return CheckboxListTile(
                      title: const Text('Producto Destacado ⭐'),
                      value: _isFeatured,
                      activeColor: const Color(0xFFE87A9B),
                      onChanged: (value) {
                        setState(() {
                          _isFeatured = value ?? false;
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar', style: TextStyle(color: Color(0xFF5A4A66))),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Navigator.of(context).pop(
                Product(
                  id: widget.product?.id ?? '',
                  name: _name,
                  description: _description,
                  price: _price,
                  imageUrl: _imageUrl,
                  stock: _stock,
                  isFeatured: _isFeatured,
                  categories: _selectedCategories,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE87A9B),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
