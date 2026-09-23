import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRepository {
  static const String _onboardingKey = 'isInitialOnboarding';

  // onboarding is true unless the intro has been finished or skipped once
  Future<bool> isInitialOnboarding() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_onboardingKey) ?? true;
  }

  // remember the intro is done so it never shows again
  Future<void> completeOnboarding() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_onboardingKey, false);
  }
}
