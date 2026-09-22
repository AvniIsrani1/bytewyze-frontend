import 'package:flutter/material.dart';
import 'package:local_fork/core/theme/app_theme.dart';
import 'package:local_fork/features/equipment/selector/equipment_selector_screen.dart';

void main() {
  runApp(MaterialApp(
    title: 'Local Fork - Equipment Dev',
    theme: AppTheme.lightTheme(),
    home: const EquipmentSelectorScreen(),
  ));
}