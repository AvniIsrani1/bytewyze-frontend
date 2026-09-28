import 'package:flutter/foundation.dart';
import 'package:local_fork/features/equipment/equipment_repository.dart';
import 'equipment_selector_state.dart';

class EquipmentSelectorController extends ChangeNotifier {
  final EquipmentRepository _repository = EquipmentRepository();

  EquipmentSelectorState _state = const EquipmentSelectorState();
  EquipmentSelectorState get state => _state;

  // Convenience: the ordered list of category names, e.g. ['Cooking Appliances', 'Cookware']
  // TODO: return _repository.categories

  // Convenience: the equipment items for whatever category the user is currently on
  // TODO: use _repository.getByCategory(...) with the category at the current step index

  // TODO: isSelected(String id) -> bool
  //   check whether id is in _state.selectedEquipmentIds

  // TODO: toggleItem(String id)
  //   if id is already selected, remove it; otherwise add it
  //   build a new Set (don't mutate the old one directly)
  //   _state = _state.copyWith(selectedEquipmentIds: ...)
  //   notifyListeners()

  // TODO: nextStep()
  //   only increment currentStepIndex if it's not already the last category
  //   _state = _state.copyWith(currentStepIndex: ...)
  //   notifyListeners()

  // TODO: previousStep()
  //   only decrement if currentStepIndex > 0
  //   same copyWith + notifyListeners() pattern
}