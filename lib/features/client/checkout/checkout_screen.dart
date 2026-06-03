// File: lib/features/client/checkout/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/providers/cart_provider.dart';
import 'package:floreria_ajolote/core/providers/user_profile_provider.dart';
import 'package:floreria_ajolote/core/providers/orders_provider.dart';
import 'package:floreria_ajolote/core/models/order.dart';
import 'package:floreria_ajolote/core/widgets/axolotl_mascot.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  String _paymentMethod = 'Tarjeta';
  bool _orderPlaced = false;
  bool _isLoading = false;

  final List<String> _paymentOptions = [
    'Tarjeta',
    'Efectivo / Oxxo',
    'Transferencia Bancaria',
  ];

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final cart = ref.read(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final userProfileAsync = ref.read(userProfileProvider);

    userProfileAsync.when(
      data: (profile) async {
        if (profile == null) return;

        final total = cartNotifier.calculateTotal();
        final order = Order(
          userId: profile.uid,
          items: cart
              .map((item) => OrderItem(
                    productId: item.product.id,
                    productName: item.product.name,
                    quantity: item.quantity,
                    price: item.product.price,
                    imageUrl: item.product.imageUrl,
                  ))
              .toList(),
          orderDate: DateTime.now(),
          totalAmount: total,
          status: OrderStatus.pending,
          paymentStatus: PaymentStatus.pending,
          shippingAddress: _addressController.text,
          paymentMethod: _paymentMethod,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );

        await ref.read(orderNotifierProvider.notifier).addOrder(order);
        cartNotifier.clearCart();

        if (mounted) {
          setState(() {
            _orderPlaced = true;
            _isLoading = false;
          });
        }
      },
      loading: () => setState(() => _isLoading = false),
      error: (e, _) => setState(() => _isLoading = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final total = cartNotifier.calculateTotal();

    if (_orderPlaced) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFF0F5),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AxolotlMascot(
                  state: AxolotlState.success,
                  size: 200,
                  message: '¡Pedido confirmado! 🎉\nTe lo llevamos con amor 🌸',
                ),
                const SizedBox(height: 32),
                const Text(
                  '¡Gracias por tu compra!',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5A4A66)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tu pedido ha sido registrado y\nserá atendido muy pronto.',
                  style: TextStyle(color: Color(0xFF5A4A66), fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE87A9B),
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Volver a la Tienda',
                      style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF0F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFFE87A9B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Confirmar Pedido',
          style: TextStyle(
              color: Color(0xFFE87A9B), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order summary
              _SectionHeader(title: '🛍️ Resumen del Pedido'),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                color: Colors.white,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      ...cart.map((item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.product.name} x${item.quantity}',
                                    style: const TextStyle(
                                        color: Color(0xFF5A4A66), fontSize: 13),
                                  ),
                                ),
                                Text(
                                  '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      color: Color(0xFFE87A9B),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5A4A66),
                                  fontSize: 16)),
                          Text(
                            '\$${total.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE87A9B),
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Shipping info
              _SectionHeader(title: '📍 Dirección de Entrega'),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                color: Colors.white,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _addressController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Dirección completa',
                          hintText: 'Calle, número, colonia, ciudad...',
                          prefixIcon: Icon(Icons.location_on_rounded,
                              color: Color(0xFFE87A9B)),
                        ),
                        validator: (v) => v!.isEmpty ? 'Ingresa la dirección' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'Notas adicionales (opcional)',
                          hintText: 'Instrucciones especiales de entrega...',
                          prefixIcon: Icon(Icons.notes_rounded,
                              color: Color(0xFFE87A9B)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Payment method
              _SectionHeader(title: '💳 Método de Pago'),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                color: Colors.white,
                elevation: 2,
                child: Column(
                  children: _paymentOptions.map((option) {
                    return RadioListTile<String>(
                      title: Text(option,
                          style: const TextStyle(color: Color(0xFF5A4A66))),
                      value: option,
                      groupValue: _paymentMethod,
                      activeColor: const Color(0xFFE87A9B),
                      onChanged: (v) => setState(() => _paymentMethod = v!),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 28),

              // Confirm button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE87A9B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text(
                          '🌸 Confirmar Pedido',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF5A4A66),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
