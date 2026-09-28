import 'package:flutter/foundation.dart';
import 'package:local_fork/core/models/models.dart';
import 'package:local_fork/features/equipment/equipment_repository.dart';
import 'equipment_selector_state.dart';

class EquipmentSelectorController extends ChangeNotifier {
  final EquipmentRepository _repository = EquipmentRepository();

  EquipmentSelectorState _state = const EquipmentSelectorState();
  EquipmentSelectorState get state => _state;

  List<String> get categories => _repository.categories;

  List<Equipment> get currentCategoryItems =>
      _repository.getByCategory(categories[_state.currentStepIndex]);

  bool get isFirstStep => _state.currentStepIndex == 0;
  bool get isLastStep => _state.currentStepIndex == categories.length - 1;

  bool isSelected(String id) => _state.selectedEquipmentIds.contains(id);

  void toggleItem(String id) {
    final updated = Set<String>.from(_state.selectedEquipmentIds);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    _state = _state.copyWith(selectedEquipmentIds: updated);
    notifyListeners();
  }

  void nextStep() {
    if (!isLastStep) {
      _state = _state.copyWith(currentStepIndex: _state.currentStepIndex + 1);
      notifyListeners();
    }
  }

  void previousStep() {
    if (!isFirstStep) {
      _state = _state.copyWith(currentStepIndex: _state.currentStepIndex - 1);
      notifyListeners();
    }
  }
}