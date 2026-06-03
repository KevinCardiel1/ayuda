
// File: lib/core/providers/products_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/models/product.dart';
import 'package:floreria_ajolote/core/providers/firebase_provider.dart';

final productsProvider = StreamProvider<List<Product>>((ref) {
  return ref.watch(firebaseProvider).getProducts();
});

final productNotifierProvider = StateNotifierProvider<ProductNotifier, AsyncValue<List<Product>>>((ref) {
  return ProductNotifier(ref);
});

class ProductNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final Ref _ref;

  ProductNotifier(this._ref) : super(const AsyncValue.loading()) {
    _ref.watch(firebaseProvider).getProducts().listen((products) {
      state = AsyncValue.data(products);
    });
  }

  Future<void> addProduct(Product product) async {
    await _ref.read(firebaseProvider).addProduct(product);
  }

  Future<void> updateProduct(Product product) async {
    await _ref.read(firebaseProvider).updateProduct(product);
  }

  Future<void> deleteProduct(String id) async {
    await _ref.read(firebaseProvider).deleteProduct(id);
  }
}
