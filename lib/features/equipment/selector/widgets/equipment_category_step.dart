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
          child: ListView(
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
                  _EquipmentTile(
                    item: item,
                    selected: isSelected(item.id),
                    onTap: () => onToggle(item.id),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _EquipmentTile extends StatelessWidget {
  const _EquipmentTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final Equipment item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final contentColor = selected ? colorScheme.primary : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.xs,
        ),
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              item.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: Colors.grey.shade800),
            ),
            Container(
              color: selected
                  ? colorScheme.secondary.withValues(alpha: 0.75)
                  : colorScheme.primary.withValues(alpha: 0.85),
            ),
            Positioned(
              top: AppSpacing.s,
              left: AppSpacing.s,
              child: Icon(
                selected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: contentColor,
              ),
            ),
            Center(
              child: Text(
                item.name,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: contentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}