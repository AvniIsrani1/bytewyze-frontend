import 'package:flutter/material.dart';
import 'package:local_fork/core/theme/app_theme.dart';
import 'package:local_fork/features/authentication/signup/signup_page.dart';
import 'package:local_fork/features/grocery_list/grocery_list_page.dart';
import 'package:flutter/rendering.dart';
import 'package:local_fork/features/onboarding/onboarding_page.dart';
import 'package:local_fork/features/onboarding/onboarding_repository.dart';

Future<void> main() async {
  // debugPaintSizeEnabled = true;

  WidgetsFlutterBinding.ensureInitialized();

  // check if this is the first download of the app (if yes, onboarding flow will be followed)
  final isInitialOnboarding = await OnboardingRepository()
      .isInitialOnboarding();

  runApp(MyApp(isInitialOnboarding: isInitialOnboarding));
}

class MyApp extends StatelessWidget {
  final bool isInitialOnboarding;

  const MyApp({super.key, required this.isInitialOnboarding});

  // This widget is the root of the application
  @override
  Widget build(BuildContext context) {
    const title = 'Local Fork';

    return MaterialApp(
      title: title,
      theme: AppTheme.lightTheme(),
      home: isInitialOnboarding
          ? const OnboardingPage()
          : SignupPage(title: title),
    );
  }
}
