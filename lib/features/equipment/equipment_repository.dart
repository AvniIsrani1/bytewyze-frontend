import 'package:local_fork/core/models/models.dart';

class EquipmentRepository {
  static const List<Equipment> _allEquipment = [
    // Cooking Appliances

    // hot food
    Equipment(id: 'oven', name: 'Oven', category: 'Cooking Appliances', subcategory: 'Hot Appliances'),
    Equipment(id: 'stovetop', name: 'Stovetop', category: 'Cooking Appliances', subcategory: 'Hot Appliances'),
    Equipment(id: 'microwave', name: 'Microwave', category: 'Cooking Appliances', subcategory: 'Hot Appliances'),
    Equipment(id: 'air_fryer', name: 'Air Fryer', category: 'Cooking Appliances', subcategory: 'Hot Appliances'),
    Equipment(id: 'instant_pot', name: 'Instant Pot', category: 'Cooking Appliances', subcategory: 'Hot Appliances'),
    Equipment(id: 'slow_cooker', name: 'Slow Cooker', category: 'Cooking Appliances', subcategory: 'Hot Appliances'),
    Equipment(id: 'sous_vide', name: 'Sous Vide Immersion Circulator', category: 'Cooking Appliances', subcategory: 'Hot Appliances'),
    Equipment(id: 'rice_cooker', name: 'Rice Cooker', category: 'Cooking Appliances', subcategory: 'Hot Appliances'),
    Equipment(id: 'waffle_maker', name: 'Waffle Maker', category: 'Cooking Appliances', subcategory: 'Hot Appliances'),
    Equipment(id: 'outdoor_grill', name: 'Outdoor Grill', category: 'Cooking Appliances', subcategory: 'Hot Appliances'),
    // mixers, blenders, and grinders
    Equipment(id: 'blender', name: 'Blender', category: 'Cooking Appliances', subcategory: 'Mixers, Blenders & Grinders'),
    Equipment(id: 'food_processor', name: 'Food Processor', category: 'Cooking Appliances', subcategory: 'Mixers, Blenders & Grinders'),
    Equipment(id: 'stand_mixer', name: 'Stand Mixer', category: 'Cooking Appliances', subcategory: 'Mixers, Blenders & Grinders'),
    Equipment(id: 'meat_grinder', name: 'Meat Grinder', category: 'Cooking Appliances', subcategory: 'Mixers, Blenders & Grinders'),
    // drink/liquid
    Equipment(id: 'coffee_machine', name: 'Coffee Machine', category: 'Cooking Appliances', subcategory: 'Drinks'),
    Equipment(id: 'espresso_machine', name: 'Espresso Machine', category: 'Cooking Appliances', subcategory: 'Drinks'),
    Equipment(id: 'electric_kettle', name: 'Electric Kettle', category: 'Cooking Appliances', subcategory: 'Drinks'),

    // Cookware

    // pans and pots
    Equipment(id: 'saucepan', name: 'Saucepan', category: 'Cookware', subcategory: 'Pans & Pots'),
    Equipment(id: 'skillet', name: 'Frying Pan (Nonstick/Steel)', category: 'Cookware', subcategory: 'Pans & Pots'),
    Equipment(id: 'cast_iron_skillet', name: 'Cast Iron Skillet', category: 'Cookware', subcategory: 'Pans & Pots'),
    Equipment(id: 'wok', name: 'Wok', category: 'Cookware', subcategory: 'Pans & Pots'),
    Equipment(id: 'pot', name: 'Pot', category: 'Cookware', subcategory: 'Pans & Pots'),
    // baking equipment
    Equipment(id: 'baking_sheet', name: 'Baking Sheet', category: 'Cookware', subcategory: 'Baking Equipment'),
    Equipment(id: 'baking_dish', name: 'Baking Dish', category: 'Cookware', subcategory: 'Baking Equipment'),
    Equipment(id: 'dutch_oven', name: 'Dutch Oven', category: 'Cookware', subcategory: 'Baking Equipment'),
  ];

  List<String> get categories =>
      _allEquipment.map((e) => e.category).toSet().toList();

  List<Equipment> getByCategory(String category) =>
      _allEquipment.where((e) => e.category == category).toList();

  List<Equipment> getSelected(Set<String> ids) =>
    _allEquipment.where((e) => ids.contains(e.id)).toList();
}