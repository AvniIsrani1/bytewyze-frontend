import 'package:flutter/foundation.dart';
import 'package:local_fork/core/models/food_category.dart';
import 'package:local_fork/core/models/pantry_item.dart';
import 'package:local_fork/features/pantry/pantry_state.dart';

class PantryController extends ChangeNotifier {
  PantryState _pantryState;

  // initialItems for preview entrypoint to see stocked pantry (will fix this before the connecting to scanner and backend)
  PantryController({List<PantryItem> initialItems = const []})
    : _pantryState = PantryState(items: initialItems);

  // getter
  PantryState get pantryState => _pantryState;

  // setter
  void _setState(PantryState newPantryState) {
    _pantryState = newPantryState;
    notifyListeners();
  }

  // one row per product --> rescanning will fold into existing card
  int _indexOf(String barcode) =>
      _pantryState.items.indexWhere((item) => item.product.barcode == barcode);

  void _replaceAt(int index, PantryItem item) {
    final items = [..._pantryState.items];
    items[index] = item;
    _setState(_pantryState.copyWith(items: items));
  }

  // an item with no batches left is off the shelf
  void _replaceOrDrop(int index, PantryItem item) {
    if (item.batches.isEmpty) {
      final items = [..._pantryState.items]..removeAt(index);
      _setState(_pantryState.copyWith(items: items));
      return;
    }
    _replaceAt(index, item);
  }

  // two dates are the same batch when they fall on the same day, and two
  // undated units also belong together
  bool _sameDate(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return a == null && b == null;
    }
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  int _batchIndex(PantryItem item, DateTime? expiresOn) =>
      item.batches.indexWhere((batch) => _sameDate(batch.expiresOn, expiresOn));

  // folds the incoming batches into the matching card, merging any that share an expiry date and keeping the rest as separate dates on the same row
  void addItem(PantryItem item) {
    final existing = _indexOf(item.product.barcode);

    if (existing < 0) {
      _setState(_pantryState.copyWith(items: [..._pantryState.items, item]));
      return;
    }

    var stocked = _pantryState.items[existing];
    for (final incoming in item.batches) {
      stocked = _merge(stocked, incoming);
    }
    _replaceAt(existing, stocked);
  }

  PantryItem _merge(PantryItem item, PantryBatch incoming) {
    final batches = [...item.batches];
    final match = _batchIndex(item, incoming.expiresOn);

    if (match < 0) {
      batches.add(incoming);
    } else {
      final existing = batches[match];
      batches[match] = existing.copyWith(
        count: existing.count + incoming.count,
      );
    }

    return item.copyWith(batches: batches);
  }

  // adds to whichever batch expires first, matching how decrement eats down
  void increment(String barcode) {
    final index = _indexOf(barcode);
    if (index < 0) {
      return;
    }
    final item = _pantryState.items[index];
    final target = item.nextToExpire;
    _replaceAt(
      index,
      _withBatch(item, target, target.copyWith(count: target.count + 1)),
    );
  }

  // take the soonest-expiring unit first, dropping the batch when it empties
  void decrement(String barcode) {
    final index = _indexOf(barcode);
    if (index < 0) {
      return;
    }
    final item = _pantryState.items[index];
    final target = item.nextToExpire;

    if (target.count <= 1) {
      _replaceOrDrop(index, _withBatch(item, target, null));
      return;
    }

    _replaceAt(
      index,
      _withBatch(item, target, target.copyWith(count: target.count - 1)),
    );
  }

  // swap a batch for a new version, or drop it when replacement is null
  PantryItem _withBatch(
    PantryItem item,
    PantryBatch target,
    PantryBatch? replacement,
  ) {
    final batches = <PantryBatch>[];
    var replaced = false;

    for (final batch in item.batches) {
      if (!replaced && _sameDate(batch.expiresOn, target.expiresOn)) {
        replaced = true;
        if (replacement != null) {
          batches.add(replacement);
        }
        continue;
      }
      batches.add(batch);
    }

    return item.copyWith(batches: batches);
  }

  // takes the whole card off the shelf, every date included
  void remove(String barcode) {
    final items = _pantryState.items
        .where((item) => item.product.barcode != barcode)
        .toList();
    _setState(_pantryState.copyWith(items: items));
  }

  // drops a single date from a card, leaving the other dates stocked
  void removeBatch(String barcode, DateTime? expiresOn) {
    final index = _indexOf(barcode);
    if (index < 0) {
      return;
    }
    final item = _pantryState.items[index];
    final match = _batchIndex(item, expiresOn);
    if (match < 0) {
      return;
    }
    _replaceOrDrop(index, _withBatch(item, item.batches[match], null));
  }

  // retargets one date on a card, merging if that lands on a date already there
  void setBatchExpiry(String barcode, DateTime? from, DateTime? to) {
    final index = _indexOf(barcode);
    if (index < 0 || _sameDate(from, to)) {
      return;
    }

    final item = _pantryState.items[index];
    final match = _batchIndex(item, from);
    if (match < 0) {
      return;
    }

    final moving = item.batches[match];
    final without = _withBatch(item, moving, null);
    _replaceAt(
      index,
      _merge(
        without,
        moving.copyWith(expiresOn: to, clearExpiresOn: to == null),
      ),
    );
  }

  // Open Food Facts leaves lot of products uncategorised, so the user has to be able to move a card into the right section by hand
  void setCategory(String barcode, FoodCategory category) {
    final index = _indexOf(barcode);
    if (index < 0) {
      return;
    }
    _replaceAt(index, _pantryState.items[index].copyWith(category: category));
  }

  void rename(String barcode, String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return;
    }
    final index = _indexOf(barcode);
    if (index < 0) {
      return;
    }
    _replaceAt(index, _pantryState.items[index].copyWith(customName: trimmed));
  }
}
