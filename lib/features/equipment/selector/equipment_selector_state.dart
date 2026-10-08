class EquipmentSelectorState {
  final int currentStepIndex;
  final Set<String> selectedEquipmentIds;

  const EquipmentSelectorState({
    this.currentStepIndex = 0,
    this.selectedEquipmentIds = const {},
  });

  EquipmentSelectorState copyWith({
    int? currentStepIndex,
    Set<String>? selectedEquipmentIds,
  }) {
    return EquipmentSelectorState(
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      selectedEquipmentIds: selectedEquipmentIds ?? this.selectedEquipmentIds,
    );
  }
}