import 'package:flutter/material.dart';
import 'package:local_fork/core/models/scanned_item.dart';
import 'package:local_fork/core/theme/app_spacing.dart';

class ScannedItemTile extends StatelessWidget {
  static const double _thumbnailSize = 48;

  final ScannedItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;
  final VoidCallback onRename;

  const ScannedItemTile({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    required this.onRename,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: ValueKey(item.barcode),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: ColoredBox(
        color: colorScheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.only(right: AppSpacing.l),
          child: Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.delete_outline,
              color: colorScheme.onErrorContainer,
            ),
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
        leading: _Thumbnail(item: item, size: _thumbnailSize),
        title: Text(
          item.isLookingUp ? item.barcode : item.displayName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodyMedium,
        ),
        subtitle: _subtitle(context),
        onTap: item.needsName ? onRename : null,
        trailing: _QuantityStepper(
          quantity: item.quantity,
          onIncrement: onIncrement,
          onDecrement: onDecrement,
        ),
      ),
    );
  }

  Widget _subtitle(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (item.isLookingUp) {
      return Text('Looking up...', style: textTheme.bodySmall);
    }

    if (item.needsName) {
      return Text(
        'Not recognized - tap to name',
        style: textTheme.bodySmall?.copyWith(color: colorScheme.tertiary),
      );
    }

    return Text(
      item.product.subtitle ?? item.barcode,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: textTheme.bodySmall,
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final ScannedItem item;
  final double size;

  const _Thumbnail({required this.item, required this.size});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final imageUrl = item.product.imageUrl;

    Widget content;
    if (item.isLookingUp) {
      content = const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    } else if (imageUrl != null) {
      content = Image.network(
        imageUrl,
        fit: BoxFit.cover,
        // missing image should not break the row
        errorBuilder: (context, error, stackTrace) => _fallback(colorScheme),
      );
    } else {
      content = _fallback(colorScheme);
    }

    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ColoredBox(
          color: colorScheme.surfaceContainerHighest,
          child: content,
        ),
      ),
    );
  }

  Widget _fallback(ColorScheme colorScheme) {
    return Center(
      child: Icon(
        Icons.shopping_basket_outlined,
        size: 22,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantityStepper({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onDecrement,
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.remove_circle_outline),
          tooltip: 'Remove one',
        ),
        SizedBox(
          width: 24,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
          onPressed: onIncrement,
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.add_circle_outline),
          tooltip: 'Add one',
        ),
      ],
    );
  }
}
