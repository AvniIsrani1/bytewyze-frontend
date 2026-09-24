import 'package:flutter/material.dart';
import 'package:local_fork/core/theme/app_spacing.dart';
import 'package:local_fork/core/util/overall_padding.dart';
import 'package:local_fork/features/grocery_list/grocery_list_controller.dart';

/*
  Displays the grocery list and fowards user actions to its controller.
  This page owns the GroceryListController, listens for its state changes, 
  and rebuilds whenever the controller calls notifyListeners().
*/
class GroceryListPage extends StatefulWidget {
  const GroceryListPage({super.key});

  @override
  State<GroceryListPage> createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {
  // Controls this page's validation, input, grocery items, and user actions.
  late final GroceryListController groceryListController;

  // Creates the controller and begins listening for state changes.
  @override
  void initState() {
    super.initState();
    groceryListController = GroceryListController();
    groceryListController.addListener(_refresh);
  }

  /*
    Rebuilds the page after the controller reports state change. 
    Mounted check prevents setState() from running after page has 
been removed from the widget tree.
  */
  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  /*
    Asks controller to validate and add current input.
    Keyboard is dismissed only after an item has been added successfully. 
  */
  void _addItem() {
    final itemWasAdded = groceryListController.addItem();

    if (itemWasAdded) {
      FocusScope.of(context).unfocus();
    }
  }

  // Stops listening and releases controller resources when page closes.
  @override
  void dispose() {
    groceryListController.removeListener(_refresh);
    groceryListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Read controller's current state once for this build.
    final state = groceryListController.groceryListState;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Grocery List')),
      body: OverallPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Form contains the item name input and Add action
            Form(
              key: groceryListController.formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: groceryListController.itemController,
                      validator: groceryListController.validateItemName,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Grocery item',
                        hintText: 'For example, apples',
                      ),

                      // Pressing keyboard's Done/enter button performs
                      // same action as pressing Add button
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

            // Displaying total gives immediate feedback after changes
            Text(
              '${state.items.length} '
              '${state.items.length == 1 ? 'item' : 'items'}',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.s),

            // Expanded gives the list all remaining vertical space
            // while allowing a long grocery list to scroll.
            Expanded(
              child: state.items.isEmpty
                  ? const _EmptyGroceryList()
                  : ListView.separated(
                      itemCount: state.items.length,
                      // Place divider between items without adding one after final item.
                      separatorBuilder: (context, index) {
                        return const Divider(height: 1);
                      },
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        // Each row allows user to mark an item purchased or remove from list
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
                              /*
                                A line through purchased items provides clear
                                visual indication without removing item.
                              */
                              decoration: item.isPurchased
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          secondary: IconButton(
                            tooltip: 'Remove ${item.name}',
                            onPressed: () {
                              groceryListController.removeItem(item.id);

                              /*
                                SnackBar provides immediate feedback after removing an item.
                                ScaffoldMessenger is used to show the SnackBar in the current context.
                                TODO: Consider timing of SnackBar display, slow reaction time rn
                              */
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${item.name} removed')),
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

/*
  Displayed in place of the list when no grocery items have been added.
  Separate widget keeps build() method clean and focused on the main page layout.
*/
class _EmptyGroceryList extends StatelessWidget {
  const _EmptyGroceryList();

  @override
  Widget build(BuildContext context) {
    /*
      Use shared theme 
    */
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              // TODO: Consider using custom item/logo, edit placement on screen.
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
