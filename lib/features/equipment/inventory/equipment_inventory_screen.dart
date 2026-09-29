import 'package:flutter/material.dart';
import 'package:local_fork/core/models/models.dart';
import 'package:local_fork/core/theme/app_spacing.dart';
import 'package:local_fork/core/util/overall_padding.dart';
import 'package:local_fork/features/equipment/selector/equipment_selector_controller.dart';

class EquipmentInventoryScreen extends StatelessWidget {
  const EquipmentInventoryScreen({super.key, required this.controller});

  final EquipmentSelectorController controller;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final selected = controller.selectedEquipment;

    final groupedItems = <String, List<Equipment>>{};
    for (final item in selected) {
      groupedItems.putIfAbsent(item.category, () => []).add(item);
    }

    return Scaffold(
      body: OverallPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.m),
            Text('Your Equipment', style: textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Container(
              height: 4,
              width: 48,
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSpacing.l),
            Expanded(
              child: selected.isEmpty
                  ? Center(
                      child: Text(
                        "You haven't added any equipment yet.",
                        style: textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Card(
                      child: ListView(
                        padding:
                            const EdgeInsets.symmetric(vertical: AppSpacing.s),
                        children: [
                          for (final entry in groupedItems.entries) ...[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                AppSpacing.m,
                                AppSpacing.m,
                                AppSpacing.m,
                                AppSpacing.xs,
                              ),
                              child: Text(
                                entry.key,
                                style: textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                            for (final item in entry.value)
                              ListTile(
                                leading: Icon(Icons.check_circle,
                                    color: colorScheme.secondary),
                                title:
                                    Text(item.name, style: textTheme.bodyMedium),
                              ),
                          ],
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: AppSpacing.l),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Add/Remove Equipment'),
            ),
          ],
        ),
      ),
    );
  }
}