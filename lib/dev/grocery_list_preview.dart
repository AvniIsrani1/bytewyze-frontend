import 'package:flutter/material.dart';
import 'package:local_fork/core/theme/app_theme.dart';
import 'package:local_fork/features/grocery_list/grocery_list_page.dart';

void main() {
  runApp(const GroceryListPreviewApp());
}

class GroceryListPreviewApp extends StatelessWidget {
  const GroceryListPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery List Preview',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      home: const GroceryListPage(),
    );
  }
}