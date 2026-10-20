// groups pantry items
// based on Open Food Facts food_groups_tags when a barcode is known
// else is picked by the user
enum FoodCategory {
  produce('produce', 'Produce'),
  dairy('dairy', 'Dairy & Eggs'),
  meatFish('meat_fish', 'Meat & Fish'),
  grains('grains', 'Grains'),
  snacks('snacks', 'Snacks'),
  drinks('drinks', 'Drinks'),
  condiments('condiments', 'Condiments'),
  prepared('prepared', 'Prepared'),
  other('other', 'Other');

  final String apiName;
  final String label;

  const FoodCategory(this.apiName, this.label);

  static FoodCategory fromApiName(String? value) {
    return FoodCategory.values.firstWhere(
      (category) => category.apiName == value,
      orElse: () => FoodCategory.other,
    );
  }

  // order the grid sections appear in, most perishable first
  static const List<FoodCategory> displayOrder = [
    produce,
    dairy,
    meatFish,
    grains,
    snacks,
    drinks,
    condiments,
    prepared,
    other,
  ];
}
