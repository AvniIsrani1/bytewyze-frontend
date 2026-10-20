class GroceryItem {
  const GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.isCompleted,
  });

  final int id;
  final String name;
  final int quantity;
  final bool isCompleted;

  factory GroceryItem.fromJson(Map<String, dynamic> json) {
    return GroceryItem(
      id: json['id'] as int,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      isCompleted: json['is_completed'] as bool,
    );
  }
}