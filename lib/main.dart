import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:local_fork/core/theme/app_theme.dart';
import 'package:local_fork/features/authentication/signup/signup_page.dart';
import 'package:local_fork/features/barcode_scanning/barcode_page.dart';
import 'package:local_fork/features/grocery_list/grocery_list_page.dart';
import 'package:local_fork/features/onboarding/onboarding_page.dart';
import 'package:local_fork/features/onboarding/onboarding_repository.dart';
import 'firebase_options.dart';
import 'package:local_fork/features/pantry/pantry_page.dart';

Future<void> main() async {
  // debugPaintSizeEnabled = true;

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  // check if this is the first download of the app (if yes, onboarding flow will be followed)
  final isInitialOnboarding = await OnboardingRepository()
      .isInitialOnboarding();

  runApp(MyApp(isInitialOnboarding: isInitialOnboarding));
}

class MyApp extends StatelessWidget {
  // temporarily open straight into a specific page so we can see what it looks like 
  // this will be removed so only onboarding flag remains
  // e.g. flutter run --dart-define=SCANNER_HOME=true
  static const bool _scannerHome = bool.fromEnvironment('SCANNER_HOME');
  static const bool _pantryHome = bool.fromEnvironment('PANTRY_HOME');  
  static const bool _groceryHome = bool.fromEnvironment('GROCERY_HOME');

  final bool isInitialOnboarding;
  const MyApp({super.key, required this.isInitialOnboarding});

  Widget _home() {
    // start of items to remove
    if (_scannerHome) {
      return const BarcodePage();
    }
    if(_pantryHome){
      return const PantryPage();
    }
    if(_groceryHome){
      return const GroceryListPage();
    }
    // end of remove 

    if (isInitialOnboarding) {
      return const OnboardingPage();
    }
    return const SignupPage(title: 'Local Fork');
  }

  // This widget is the root of the application
  @override
  Widget build(BuildContext context) {
    const title = 'Local Fork';

    return MaterialApp(
      title: title,
      theme: AppTheme.lightTheme(),
      home: _home(),
    );
  }
}
