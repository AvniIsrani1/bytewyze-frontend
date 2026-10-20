import 'package:flutter/foundation.dart';
import 'package:local_fork/core/models/food_category.dart';
import 'package:local_fork/core/models/product.dart';

// how close an item is to its expiration date
enum Freshness { fresh, soon, urgent, expired, unknown }

// strip time part for easy day comparisons
DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

// each product will have date tracked separately
// most recent date will be what exp bar is based on
@immutable
class PantryBatch {
  final int count;
  final DateTime addedOn;
  final DateTime? expiresOn;

  const PantryBatch({required this.addedOn, this.count = 1, this.expiresOn});

  // whole days from today until expiry, negative once it has passed
  int? get daysLeft {
    final expiry = expiresOn;
    if (expiry == null) {
      return null;
    }
    return _dateOnly(expiry).difference(_dateOnly(DateTime.now())).inDays;
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

  // 0...1 share of this batch's shelf life still left (for the bar width)
  // null when there is no expiry date
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

  PantryBatch copyWith({
    int? count,
    DateTime? addedOn,
    DateTime? expiresOn,
    bool clearExpiresOn = false,
  }) {
    return PantryBatch(
      count: count ?? this.count,
      addedOn: addedOn ?? this.addedOn,
      expiresOn: clearExpiresOn ? null : (expiresOn ?? this.expiresOn),
    );
  }

  factory PantryBatch.fromJson(Map<String, dynamic> json) {
    return PantryBatch(
      count: json['count'] as int? ?? 1,
      addedOn: DateTime.parse(json['input_date'] as String),
      expiresOn: json['exp_date'] == null
          ? null
          : DateTime.parse(json['exp_date'] as String),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PantryBatch &&
      other.count == count &&
      other.addedOn == addedOn &&
      other.expiresOn == expiresOn;

  @override
  int get hashCode => Object.hash(count, addedOn, expiresOn);
}

@immutable
class PantryItem {
  final Product product;
  final FoodCategory category;
  final String? customName;

  // one entry per distinct expiration date
  // controller keeps dates unique within this list, so date doubles as batch's identity
  final List<PantryBatch> batches;

  const PantryItem({
    required this.product,
    required this.batches,
    this.category = FoodCategory.other,
    this.customName,
  });

  // convenience for the common case of adding a single dated unit
  factory PantryItem.single({
    required Product product,
    required DateTime addedOn,
    FoodCategory category = FoodCategory.other,
    DateTime? expiresOn,
    String? customName,
    int count = 1,
  }) {
    return PantryItem(
      product: product,
      category: category,
      customName: customName,
      batches: [
        PantryBatch(addedOn: addedOn, count: count, expiresOn: expiresOn),
      ],
    );
  }

  String get barcode => product.barcode;

  String get displayName => customName ?? product.displayName;

  String? get subtitle => product.subtitle;

  // every unit on the shelf, across all batches
  int get count => batches.fold(0, (total, batch) => total + batch.count);

  bool get hasMultipleDates => batches.length > 1;

  // soonest expiry first, undated batches last
  List<PantryBatch> get batchesByExpiry {
    final sorted = [...batches];
    sorted.sort((a, b) {
      final aDays = a.daysLeft;
      final bDays = b.daysLeft;
      if (aDays == null && bDays == null) {
        return 0;
      }
      if (aDays == null) {
        return 1;
      }
      if (bDays == null) {
        return -1;
      }
      return aDays.compareTo(bDays);
    });
    return sorted;
  }

  // the batch to eat next (the one the card's bar will be based on)
  PantryBatch get nextToExpire => batchesByExpiry.first;

  int? get daysLeft => nextToExpire.daysLeft;

  Freshness get freshness => nextToExpire.freshness;

  double? get freshnessFraction => nextToExpire.freshnessFraction;

  PantryItem copyWith({
    Product? product,
    FoodCategory? category,
    String? customName,
    List<PantryBatch>? batches,
  }) {
    return PantryItem(
      product: product ?? this.product,
      category: category ?? this.category,
      customName: customName ?? this.customName,
      batches: batches ?? this.batches,
    );
  }

  factory PantryItem.fromJson(Map<String, dynamic> json) {
    return PantryItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      category: FoodCategory.fromApiName(json['category'] as String?),
      customName: json['custom_name'] as String?,
      batches: (json['batches'] as List<dynamic>)
          .map((batch) => PantryBatch.fromJson(batch as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PantryItem &&
      other.product == product &&
      other.category == category &&
      other.customName == customName &&
      listEquals(other.batches, batches);

  @override
  int get hashCode =>
      Object.hash(product, category, customName, Object.hashAll(batches));
}
