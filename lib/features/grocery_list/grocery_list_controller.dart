import 'package:flutter/material.dart';
import 'package:local_fork/features/grocery_list/grocery_list_state.dart';

class GroceryListController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final itemController = TextEditingController();

  GroceryListState _groceryListState = const GroceryListState();

  GroceryListState get groceryListState => _groceryListState;

  void _setState(GroceryListState newState) {
    _groceryListState = newState;
    notifyListeners();
  }

  String? validateItemName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Item name is required.';
    }

    if (value.trim().length > 100) {
      return 'Item name must be 100 characters or fewer.';
    }

    return null;
  }

  bool addItem() {
    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return false;
    }

    final newItem = GroceryListItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: itemController.text.trim(),
    );

    _setState(
      groceryListState.copyWith(
        items: List.unmodifiable([
          ...groceryListState.items,
          newItem,
        ]),
      ),
    );

    itemController.clear();
    return true;
  }

  void togglePurchased(String id, bool? isPurchased) {
    final updatedItems = groceryListState.items.map((item) {
      if (item.id != id) {
        return item;
      }

      return item.copyWith(
        isPurchased: isPurchased ?? false,
      );
    }).toList();

    _setState(
      groceryListState.copyWith(
        items: List.unmodifiable(updatedItems),
      ),
    );
  }

  void removeItem(String id) {
    final updatedItems = groceryListState.items
        .where((item) => item.id != id)
        .toList();

    _setState(
      groceryListState.copyWith(
        items: List.unmodifiable(updatedItems),
      ),
    );
  }

  @override
  void dispose() {
    itemController.dispose();
    super.dispose();
  }
}