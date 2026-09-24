/*
  This class represents one item in the grocery list. 
  The model is immutable, and the copyWith method is used to create a new instance with updated values.
 */
class GroceryListItem {
  const GroceryListItem({
    required this.id,
    required this.name,
    this.isPurchased = false,
  });
  // Unique identifier for the grocery list item
  final String id;
  // Name of the grocery list item
  final String name;
  // Indicates whether the item has been purchased
  final bool isPurchased;

  /*
    Creates a new instance of GroceryListItem with updated values.
    If a value is not provided, the existing value is used.
  */
  GroceryListItem copyWith({String? name, bool? isPurchased}) {
    return GroceryListItem(
      id: id,
      name: name ?? this.name,
      isPurchased: isPurchased ?? this.isPurchased,
    );
  }
}

/* 
  Contains all data that the grocery list page needs to display.
  Loading and error fields can be added later when the app is connected to a backend.
*/
class GroceryListState {
  const GroceryListState({this.items = const []});

  // Current list of grocery items in the order they should appear on the screen
  final List<GroceryListItem> items;

  /* 
    Creates a new page state while preserving fields that are not provided.
    The controller class uses this method to update the state when items are added, removed, or updated.
  */
  GroceryListState copyWith({List<GroceryListItem>? items}) {
    return GroceryListState(items: items ?? this.items);
  }
}
