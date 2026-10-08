class Equipment {
  final String id;
  final String name;
  final String category;
  final String subcategory;

  const Equipment({
    required this.id,
    required this.name,
    required this.category,
    required this.subcategory,
  });

  String get imagePath => 'assets/images/equipment/$id.jpg';
}