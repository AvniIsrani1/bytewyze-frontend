import 'package:flutter/foundation.dart';

@immutable
class Product {
  final String barcode;
  final bool found;
  final String? name;
  final String? brand;
  final String? imageUrl;
  final String? size;

  const Product({
    required this.barcode,
    required this.found,
    this.name,
    this.brand,
    this.imageUrl,
    this.size,
  });

  const Product.unknown(this.barcode)
    : found = false,
      name = null,
      brand = null,
      imageUrl = null,
      size = null;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      barcode: json['barcode'] as String,
      found: json['found'] as bool? ?? false,
      name: json['name'] as String?,
      brand: json['brand'] as String?,
      imageUrl: json['image_url'] as String?,
      size: json['size'] as String?,
    );
  }

  String get displayName => name ?? 'Unknown item';

  String? get subtitle {
    final parts = [brand, size].whereType<String>();
    return parts.isEmpty ? null : parts.join(' - ');
  }

  @override
  bool operator ==(Object other) =>
      other is Product &&
      other.barcode == barcode &&
      other.found == found &&
      other.name == name &&
      other.brand == brand &&
      other.imageUrl == imageUrl &&
      other.size == size;

  @override
  int get hashCode => Object.hash(barcode, found, name, brand, imageUrl, size);
}
