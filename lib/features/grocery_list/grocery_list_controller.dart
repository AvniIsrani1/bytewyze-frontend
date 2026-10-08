import 'package:flutter/material.dart';
import 'package:local_fork/features/grocery_list/grocery_list_state.dart';

/*
  This class manages grocery list input, validation, actions, and page state.
  The page class forwards user input to this controller.
  After changing state, controller calls notifyListeners() so the page knows to rebuild. 
*/
class GroceryListController extends ChangeNotifier {
  // Connects the pages Form widget to validation in this controller.
  final formKey = GlobalKey<FormState>();
  /*
    Provides access to the text input field for the grocery item name.
    This controller must be disposed when the page is disposed.
  */
  final itemController = TextEditingController();

  // Internal state should only be changed through [_setState].
  GroceryListState _groceryListState = const GroceryListState();

  // Exposes the current state to the page, read only.
  GroceryListState get groceryListState => _groceryListState;

  /*
    Replaces the current state and tells listening widgets to rebuild.
    Keeps state management logic in one place, and prevents the page from changing state directly.
  */
  void _setState(GroceryListState newState) {
    _groceryListState = newState;
    notifyListeners();
  }

  /*
    Validates the grocery item name input.
    Returns an error message if the input is invalid, or null if it is valid.
    Input is invalid if it is empty or longer than 100 characters. (can add more validation rules later)
  */
  String? validateItemName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Item name is required.';
    }

    if (value.trim().length > 100) {
      return 'Item name must be 100 characters or fewer.';
    }

    return null;
  }

  /*
    Validates the form and adds a new item to the grocery list if valid.
    Returns true if the item was added.
    Page class uses this return value to determine whether to unfocus the text field.
  */
  bool addItem() {
    final isValid = formKey.currentState?.validate() ?? false;

    // Stop immediately if the item name did not pass validation.
    if (!isValid) {
      return false;
    }
    /*
     This locally generated ID is suitable for temp list.
     A saved version should use the permanent ID returned by FastAPI.
    */
    final newItem = GroceryListItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: itemController.text.trim(),
    );

    /*
      Creates a new state with the new item added to the end of the list.
      The list is wrapped in List.unmodifiable to prevent accidental modification outside of this controller.
    */
    _setState(
      groceryListState.copyWith(
        items: List.unmodifiable([...groceryListState.items, newItem]),
      ),
    );

    // Clear input after successfully adding item.
    itemController.clear();
    return true;
  }

  // Toggles the purchased status of a grocery list item by its ID.
  void togglePurchased(String id, bool? isPurchased) {
    // Build a new list. Only the matching item receives an updated value.
    final updatedItems = groceryListState.items.map((item) {
      if (item.id != id) {
        return item;
      }

      return item.copyWith(isPurchased: isPurchased ?? false);
    }).toList();

    _setState(
      groceryListState.copyWith(items: List.unmodifiable(updatedItems)),
    );
  }

  // Removes a grocery list item by its ID.
  void removeItem(String id) {
    // Retain every item except the one selected for removal.
    final updatedItems = groceryListState.items
        .where((item) => item.id != id)
        .toList();

    _setState(
      groceryListState.copyWith(items: List.unmodifiable(updatedItems)),
    );
  }

  // Releases objects owned by this controller when the page is removed.
  @override
  void dispose() {
    itemController.dispose();
    super.dispose();
  }
}
