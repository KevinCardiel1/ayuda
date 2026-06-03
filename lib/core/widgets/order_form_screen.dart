
// File: lib/core/widgets/order_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/models/order.dart';
import 'package:floreria_ajolote/core/providers/orders_provider.dart';
import 'package:floreria_ajolote/core/state/auth_state_notifier.dart';
import 'package:floreria_ajolote/core/providers/cart_provider.dart';

class OrderFormScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _shippingAddressController = TextEditingController();
  final _notesController = TextEditingController();

  OrderFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final authState = ref.watch(authStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('New Order')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _shippingAddressController,
                decoration: const InputDecoration(labelText: 'Shipping Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (authState is Authenticated) {
                    if (_formKey.currentState!.validate()) {
                      final newOrder = Order(
                        id: '', // Firestore will generate this
                        userId: authState.user!.uid,
                        items: cart,
                        orderDate: DateTime.now(),
                        totalAmount: cart.fold(0, (sum, item) => sum + item.product.price * item.quantity),
                        status: OrderStatus.pending,
                        shippingAddress: _shippingAddressController.text,
                        notes: _notesController.text,
                      );
                      ref.read(ordersProvider.notifier).addOrder(newOrder);
                      ref.read(cartProvider.notifier).clearCart();
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Place Order'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
