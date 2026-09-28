import 'package:local_fork/core/models/models.dart';

class EquipmentRepository {
  static const List<Equipment> _allEquipment = [
    // Cooking Appliances 

    // hot food
    Equipment(id: 'oven', name: 'Oven', category: 'Cooking Appliances'),
    Equipment(id: 'stovetop', name: 'Stovetop', category: 'Cooking Appliances'),
    Equipment(id: 'microwave', name: 'Microwave', category: 'Cooking Appliances'),
    Equipment(id: 'sous_vide', name: 'Sous Vide Immersion Circulator', category: 'Cooking Appliances'),
    Equipment(id: 'air_fryer', name: 'Air Fryer', category: 'Cooking Appliances'),
    Equipment(id: 'instant_pot', name: 'Instant Pot', category: 'Cooking Appliances'),
    Equipment(id: 'slow_cooker', name: 'Slow Cooker', category: 'Cooking Appliances'),
    Equipment(id: 'rice_cooker', name: 'Rice Cooker', category: 'Cooking Appliances'),
    Equipment(id: 'waffle_maker', name: 'Waffle Maker', category: 'Cooking Appliances'),
    Equipment(id: 'outdoor_grill', name: 'Outdoor Grill', category: 'Cooking Appliances'),
    // mixers, blenders, and grinders
    Equipment(id: 'blender', name: 'Blender', category: 'Cooking Appliances'),
    Equipment(id: 'food_processor', name: 'Food Processor', category: 'Cooking Appliances'),
    Equipment(id: 'stand_mixer', name: 'Stand Mixer', category: 'Cooking Appliances'),
    Equipment(id: 'meat_grinder', name: 'Meat Grinder', category: 'Cooking Appliances'),
    // drink/liquid 
    Equipment(id: 'coffee_machine', name: 'Coffee Machine', category: 'Cooking Appliances'),
    Equipment(id: 'espresso_machine', name: 'Espresso Machine', category: 'Cooking Appliances'),
    Equipment(id: 'electric_kettle', name: 'Electric Kettle', category: 'Cooking Appliances'),


    // Cookware

    // pans and pots
    Equipment(id: 'saucepan', name: 'Saucepan', category: 'Cookware'),
    Equipment(id: 'skillet', name: 'Frying Pan (Nonstick/Steel)', category: 'Cookware'),
    Equipment(id: 'cast_iron_skillet', name: 'Cast Iron Skillet', category: 'Cookware'),
    Equipment(id: 'wok', name: 'Wok', category: 'Cookware'),
    Equipment(id: 'pot', name: 'Pot', category: 'Cookware'),

    // baking equipment
    Equipment(id: 'baking_sheet', name: 'Baking Sheet', category: 'Cookware'),
    Equipment(id: 'baking_dish', name: 'Baking Dish', category: 'Cookware'),
    Equipment(id: 'dutch_oven', name: 'Dutch Oven', category: 'Cookware'),
    

    
  ];

  List<String> get categories =>
      _allEquipment.map((e) => e.category).toSet().toList();

  List<Equipment> getByCategory(String category) =>
      _allEquipment.where((e) => e.category == category).toList();
}