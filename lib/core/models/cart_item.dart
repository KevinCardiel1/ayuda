// File: lib/core/models/cart_item.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:floreria_ajolote/core/models/product.dart';
import 'package:floreria_ajolote/core/util/json_converter.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    @ProductConverter() required Product product,
    required int quantity,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
}
