
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/models/product.dart';
import 'package:floreria_ajolote/core/models/cart_item.dart';

// Provider for the cart notifier
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

// Cart Notifier
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  // Add a product to the cart
  void addToCart(Product product) {
    // Check if the product is already in the cart
    final existingItemIndex = state.indexWhere((item) => item.product.id == product.id);

    if (existingItemIndex != -1) {
      // If it exists, update the quantity
      final updatedItem = state[existingItemIndex].copyWith(
        quantity: state[existingItemIndex].quantity + 1,
      );
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingItemIndex) updatedItem else state[i],
      ];
    } else {
      // If it doesn't exist, add a new item
      state = [...state, CartItem(product: product, quantity: 1)];
    }
  }

  // Remove a product from the cart
  void removeFromCart(Product product) {
    final existingItemIndex = state.indexWhere((item) => item.product.id == product.id);

    if (existingItemIndex != -1) {
      if (state[existingItemIndex].quantity > 1) {
        // If quantity > 1, decrease it
        final updatedItem = state[existingItemIndex].copyWith(
          quantity: state[existingItemIndex].quantity - 1,
        );
        state = [
          for (int i = 0; i < state.length; i++)
            if (i == existingItemIndex) updatedItem else state[i],
        ];
      } else {
        // If quantity is 1, remove the item entirely
        state = state.where((item) => item.product.id != product.id).toList();
      }
    }
  }

  // Clear the entire cart
  void clearCart() {
    state = [];
  }

  // Calculate the total price of the items in the cart
  double calculateTotal() {
    return state.fold(0.0, (total, item) => total + (item.product.price * item.quantity));
  }
}
