import 'package:flutter/foundation.dart';
import 'package:local_fork/core/models/food_category.dart';
import 'package:local_fork/core/models/pantry_item.dart';

@immutable
class PantryState {
  final List<PantryItem> items;
  final String? errorMessage;

  const PantryState({this.items = const [], this.errorMessage});

  bool get isEmpty => items.isEmpty;

  // distinct products on the shelf
  int get itemCount => items.length;

  // total units (counting duplicates)
  int get totalCount => items.fold(0, (total, item) => total + item.count);

  int get expiringSoonCount => items
      .where(
        (item) =>
            item.freshness == Freshness.urgent ||
            item.freshness == Freshness.expired,
      )
      .length;

  // one grid section per category, in displayOrder, empty categories skipped
  Map<FoodCategory, List<PantryItem>> get grouped {
    final sections = <FoodCategory, List<PantryItem>>{};

    for (final category in FoodCategory.displayOrder) {
      final matches = items.where((item) => item.category == category).toList();

      if (matches.isEmpty) {
        continue;
      }

      // soonest to expire first so urgent cards start each section
      // undated items will be at bottom
      matches.sort((a, b) {
        final aDays = a.daysLeft;
        final bDays = b.daysLeft;
        if (aDays == null && bDays == null) {
          return a.displayName.compareTo(b.displayName);
        }
        if (aDays == null) {
          return 1;
        }
        if (bDays == null) {
          return -1;
        }
        return aDays.compareTo(bDays);
      });

      sections[category] = matches;
    }

    return sections;
  }

  // return new state while keeping remaining values unchanged
  PantryState copyWith({
    List<PantryItem>? items,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PantryState(
      items: items ?? this.items,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
