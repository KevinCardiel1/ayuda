
// File: lib/core/util/json_converter.dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:floreria_ajolote/core/models/product.dart';

class ProductConverter implements JsonConverter<Product, Map<String, dynamic>> {
  const ProductConverter();

  @override
  Product fromJson(Map<String, dynamic> json) {
    return Product.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Product product) {
    return product.toJson();
  }
}

