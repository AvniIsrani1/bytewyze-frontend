import 'package:flutter/foundation.dart';
import 'package:local_fork/core/models/food_category.dart';
import 'package:local_fork/core/models/product.dart';

// how close an item is to its expiration date
enum Freshness { fresh, soon, urgent, expired, unknown }

// strip time part for easy day comparisons
DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

@immutable
class PantryItem {
  final Product product;
  final int count;
  final FoodCategory category;
  final DateTime addedOn;
  final DateTime? expiresOn;
  final String? customName;

  const PantryItem({
    required this.product,
    required this.addedOn,
    this.count = 1,
    this.category = FoodCategory.other,
    this.expiresOn,
    this.customName,
  });

  String get barcode => product.barcode;

  String get displayName => customName ?? product.displayName;

  String? get subtitle => product.subtitle;

  // whole days from today until expiry, negative once it has passed
  int? get daysLeft {
    final expiry = expiresOn;
    if (expiry == null) {
      return null;
    }
    final today = _dateOnly(DateTime.now());
    return _dateOnly(expiry).difference(today).inDays;
  }

  Freshness get freshness {
    final days = daysLeft;
    if (days == null) {
      return Freshness.unknown;
    }
    if (days < 0) {
      return Freshness.expired;
    }
    if (days <= 3) {
      return Freshness.urgent;
    }
    if (days <= 7) {
      return Freshness.soon;
    }
    return Freshness.fresh;
  }

  double? get freshnessFraction {
    final expiry = expiresOn;
    final days = daysLeft;
    if (expiry == null || days == null) {
      return null;
    }
    final shelfLife = _dateOnly(expiry).difference(_dateOnly(addedOn)).inDays;
    if (shelfLife <= 0) {
      return days >= 0 ? 1.0 : 0.0;
    }
    return (days / shelfLife).clamp(0.0, 1.0);
  }

  PantryItem copyWith({
    Product? product,
    int? count,
    FoodCategory? category,
    DateTime? addedOn,
    DateTime? expiresOn,
    String? customName,
    bool clearExpiresOn = false,
  }) {
    return PantryItem(
      product: product ?? this.product,
      count: count ?? this.count,
      category: category ?? this.category,
      addedOn: addedOn ?? this.addedOn,
      expiresOn: clearExpiresOn ? null : (expiresOn ?? this.expiresOn),
      customName: customName ?? this.customName,
    );
  }

  factory PantryItem.fromJson(Map<String, dynamic> json) {
    return PantryItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      count: json['count'] as int? ?? 1,
      category: FoodCategory.fromApiName(json['category'] as String?),
      addedOn: DateTime.parse(json['input_date'] as String),
      expiresOn: json['exp_date'] == null
          ? null
          : DateTime.parse(json['exp_date'] as String),
      customName: json['custom_name'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PantryItem &&
      other.product == product &&
      other.count == count &&
      other.category == category &&
      other.addedOn == addedOn &&
      other.expiresOn == expiresOn &&
      other.customName == customName;

  @override
  int get hashCode =>
      Object.hash(product, count, category, addedOn, expiresOn, customName);
}
