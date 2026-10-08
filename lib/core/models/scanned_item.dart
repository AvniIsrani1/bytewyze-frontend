import 'package:flutter/foundation.dart';
import 'package:local_fork/core/models/product.dart';

@immutable
class ScannedItem {
  final Product product;
  final int quantity;
  final String? customName;
  final bool isLookingUp;

  const ScannedItem({
    required this.product,
    this.quantity = 1,
    this.customName,
    this.isLookingUp = false,
  });

  String get barcode => product.barcode;

  String get displayName => customName ?? product.displayName;

  bool get needsName => !product.found && customName == null && !isLookingUp;

  ScannedItem copyWith({
    Product? product,
    int? quantity,
    String? customName,
    bool? isLookingUp,
  }) {
    return ScannedItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      customName: customName ?? this.customName,
      isLookingUp: isLookingUp ?? this.isLookingUp,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ScannedItem &&
      other.product == product &&
      other.quantity == quantity &&
      other.customName == customName &&
      other.isLookingUp == isLookingUp;

  @override
  int get hashCode => Object.hash(product, quantity, customName, isLookingUp);
}
