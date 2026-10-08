import 'package:flutter/material.dart';
import 'package:local_fork/core/theme/app_spacing.dart';
import 'package:local_fork/core/util/overall_padding.dart';
import 'package:local_fork/features/pantry/pantry_controller.dart';

class PantryPage extends StatefulWidget {
  const PantryPage({super.key});

  @override
  State<PantryPage> createState() => _PantryPageState();
}

class _PantryPageState extends State<PantryPage> {
  late final PantryController pantryController;

  @override
  void initState() {
    super.initState();
    pantryController = PantryController();
    pantryController.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    pantryController.removeListener(_refresh);
    pantryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('My Pantry')),
      body: OverallPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: []
        ),
      ),
    );
  }
}
