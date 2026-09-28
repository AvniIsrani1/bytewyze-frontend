import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:local_fork/core/theme/app_theme.dart';
import 'package:local_fork/features/authentication/signup/signup_page.dart';

void main() { 
  // debugPaintSizeEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Fork',
      theme: AppTheme.lightTheme(),
      home: SignupPage(title: 'Local Fork'),
    );
  }
}