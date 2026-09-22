class GroceryListItem {
  const GroceryListItem({
    required this.id,
    required this.name,
    this.isPurchased = false,
  });

  final String id;
  final String name;
  final bool isPurchased;

  GroceryListItem copyWith({
    String? name,
    bool? isPurchased,
  }) {
    return GroceryListItem(
      id: id,
      name: name ?? this.name,
      isPurchased: isPurchased ?? this.isPurchased,
    );
  }
}

class GroceryListState {
  const GroceryListState({
    this.items = const [],
  });

  final List<GroceryListItem> items;

  GroceryListState copyWith({
    List<GroceryListItem>? items,
  }) {
    return GroceryListState(
      items: items ?? this.items,
    );
  }
}