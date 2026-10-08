import 'package:flutter/material.dart';

class PantryController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  Future<void> submit() async {
  }

  // when screen is removed, dispose of controllers
  @override
  void dispose() {
    super.dispose();
  }
}
