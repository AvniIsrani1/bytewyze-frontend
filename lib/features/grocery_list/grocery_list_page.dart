import 'package:flutter/material.dart';
import 'package:local_fork/core/theme/app_spacing.dart';
import 'package:local_fork/core/util/overall_padding.dart';
import 'package:local_fork/features/grocery_list/grocery_list_controller.dart';

class GroceryListPage extends StatefulWidget {
  const GroceryListPage({super.key});

  @override
  State<GroceryListPage> createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {
  late final GroceryListController groceryListController;

  @override
  void initState() {
    super.initState();
    groceryListController = GroceryListController();
    groceryListController.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  void _addItem() {
    final itemWasAdded = groceryListController.addItem();

    if (itemWasAdded) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    groceryListController.removeListener(_refresh);
    groceryListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = groceryListController.groceryListState;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
      ),
      body: OverallPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: groceryListController.formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: groceryListController.itemController,
                      validator: groceryListController.validateItemName,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Grocery item',
                        hintText: 'For example, apples',
                      ),
                      onFieldSubmitted: (_) => _addItem(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s),
                  IconButton(
                    onPressed: _addItem,
                    tooltip: 'Add grocery item',
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.l),
            Text(
              '${state.items.length} '
              '${state.items.length == 1 ? 'item' : 'items'}',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.s),
            Expanded(
              child: state.items.isEmpty
                  ? const _EmptyGroceryList()
                  : ListView.separated(
                      itemCount: state.items.length,
                      separatorBuilder: (context, index) {
                        return const Divider(height: 1);
                      },
                      itemBuilder: (context, index) {
                        final item = state.items[index];

                        return CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          value: item.isPurchased,
                          onChanged: (value) {
                            groceryListController.togglePurchased(
                              item.id,
                              value,
                            );
                          },
                          title: Text(
                            item.name,
                            style: TextStyle(
                              decoration: item.isPurchased
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          secondary: IconButton(
                            tooltip: 'Remove ${item.name}',
                            onPressed: () {
                              groceryListController.removeItem(item.id);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${item.name} removed'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete_outline),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyGroceryList extends StatelessWidget {
  const _EmptyGroceryList();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: colorScheme.secondary,
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              'Your grocery list is empty',
              textAlign: TextAlign.center,
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              'Add an item above to start your list.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}