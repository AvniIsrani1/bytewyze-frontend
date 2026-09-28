import 'package:flutter/material.dart';
import 'package:local_fork/core/models/models.dart';
import 'package:local_fork/core/theme/app_spacing.dart';

class EquipmentCategoryStep extends StatelessWidget {
  const EquipmentCategoryStep({
    super.key,
    required this.category,
    required this.items,
    required this.isSelected,
    required this.onToggle,
  });

  final String category;
  final List<Equipment> items;
  final bool Function(String id) isSelected;
  final void Function(String id) onToggle;

    @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final groupedItems = <String, List<Equipment>>{};
    for (final item in items) {
      groupedItems.putIfAbsent(item.subcategory, () => []).add(item);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.m),
        Text(category, style: textTheme.titleLarge),
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
          child: Card(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
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
                    CheckboxListTile(
                      value: isSelected(item.id),
                      onChanged: (_) => onToggle(item.id),
                      title: Text(item.name, style: textTheme.bodyMedium),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}