import 'package:flutter/material.dart';
import 'package:local_fork/core/theme/app_spacing.dart';
import 'package:local_fork/features/barcode_scanning/barcode_state.dart';
import 'package:local_fork/features/barcode_scanning/scanned_item_tile.dart';

class ScanCartSheet extends StatelessWidget {
  final BarcodeState barcodeState;
  final ValueChanged<String> onIncrement;
  final ValueChanged<String> onDecrement;
  final ValueChanged<String> onRemove;
  final ValueChanged<String> onRename;
  final VoidCallback onEnterManually;
  final VoidCallback onDone;

  const ScanCartSheet({
    super.key,
    required this.barcodeState,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    required this.onRename,
    required this.onEnterManually,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      snap: true,
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const _DragHandle(),
              _Header(count: barcodeState.totalCount),
              Expanded(
                child: barcodeState.isEmpty
                    ? _EmptyState(scrollController: scrollController)
                    : _ItemList(
                        barcodeState: barcodeState,
                        scrollController: scrollController,
                        onIncrement: onIncrement,
                        onDecrement: onDecrement,
                        onRemove: onRemove,
                        onRename: onRename,
                      ),
              ),
              _Actions(
                count: barcodeState.totalCount,
                onEnterManually: onEnterManually,
                onDone: onDone,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final int count;

  const _Header({required this.count});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      child: Row(
        children: [
          Text(
            'Scanned',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            count == 1 ? '1 item' : '$count items',
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ItemList extends StatelessWidget {
  final BarcodeState barcodeState;
  final ScrollController scrollController;
  final ValueChanged<String> onIncrement;
  final ValueChanged<String> onDecrement;
  final ValueChanged<String> onRemove;
  final ValueChanged<String> onRename;

  const _ItemList({
    required this.barcodeState,
    required this.scrollController,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    required this.onRename,
  });

  @override
  Widget build(BuildContext context) {
    final items = barcodeState.items;

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ScannedItemTile(
          item: item,
          onIncrement: () => onIncrement(item.barcode),
          onDecrement: () => onDecrement(item.barcode),
          onRemove: () => onRemove(item.barcode),
          onRename: () => onRename(item.barcode),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ScrollController scrollController;

  const _EmptyState({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      controller: scrollController,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Text(
            'Point the camera at a barcode. Keep scanning to add more items.',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  final int count;
  final VoidCallback onEnterManually;
  final VoidCallback onDone;

  const _Actions({
    required this.count,
    required this.onEnterManually,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.l,
          AppSpacing.s,
          AppSpacing.l,
          AppSpacing.s,
        ),
        child: Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: count == 0 ? null : onDone,
                child: Text(count == 0 ? 'Done' : 'Done ($count)'),
              ),
            ),
            const SizedBox(width: AppSpacing.s),
            IconButton.outlined(
              onPressed: onEnterManually,
              icon: const Icon(Icons.keyboard),
              tooltip: 'Enter barcode manually',
            ),
          ],
        ),
      ),
    );
  }
}
