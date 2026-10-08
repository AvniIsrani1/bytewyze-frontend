import 'package:flutter/material.dart';
import 'package:local_fork/core/theme/app_spacing.dart';
import 'package:local_fork/core/util/overall_padding.dart';
import 'package:local_fork/features/equipment/inventory/equipment_inventory_screen.dart';
import 'equipment_selector_controller.dart';
import 'widgets/equipment_category_step.dart';

class EquipmentSelectorScreen extends StatefulWidget {
  const EquipmentSelectorScreen({super.key});

  @override
  State<EquipmentSelectorScreen> createState() =>
      _EquipmentSelectorScreenState();
}

class _EquipmentSelectorScreenState extends State<EquipmentSelectorScreen> {
  late final EquipmentSelectorController controller;

  @override
  void initState() {
    super.initState();
    controller = EquipmentSelectorController();
    controller.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.removeListener(_refresh);
    controller.dispose();
    super.dispose();
  }

  void _handleNext() {
  if (controller.isLastStep) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EquipmentInventoryScreen(controller: controller),
      ),
    );
  } else {
    controller.nextStep();
  }
}

  @override
  Widget build(BuildContext context) {
    final category = controller.categories[controller.state.currentStepIndex];

    return Scaffold(
      body: OverallPadding(
        child: Column(
          children: [
            Expanded(
              child: EquipmentCategoryStep(
                category: category,
                items: controller.currentCategoryItems,
                isSelected: controller.isSelected,
                onToggle: controller.toggleItem,
              ),
            ),
            const SizedBox(height: AppSpacing.l),
            Row(
              children: [
                if (!controller.isFirstStep) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.previousStep,
                      child: const Text('Back'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleNext,
                    child: Text(controller.isLastStep ? 'Finish' : 'Next'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}