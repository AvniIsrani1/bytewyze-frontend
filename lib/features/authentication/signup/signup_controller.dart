import 'package:flutter/material.dart';
import 'package:local_fork/features/authentication/authentication_repository.dart';
import 'package:local_fork/features/authentication/signup/signup_state.dart';
import 'package:local_fork/features/authentication/signup/password_requirement.dart';

class SignupController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _authRepository = AuthenticationRepository();

  // live, interactive checklist of password criteria (rebuilt as user types)
  SignupController() {
    passwordController.addListener(notifyListeners);
  }
  // current password text
  String get password => passwordController.text;

  SignupState _signupState = const SignupState();

  // getter
  SignupState get signupState => _signupState;

  // setter
  void _setState(SignupState newSignupState) {
    _signupState = newSignupState;
    notifyListeners();
  }

  // validate email
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }
    final emailRegExp = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");
    if (!emailRegExp.hasMatch(value.trim())) {
      return "Enter a valid email";
    }
    return null;
  }

  // validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required.";
    }
    if (PasswordRequirement.unmetBy(value).isNotEmpty) {
      return "Password does not meet the requirements below.";
    }
    return null;
  }

  // validate confirm password
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password.";
    }
    if (value != passwordController.text) {
      return "Passwords do not match.";
    }
    return null;
  }

  Future<void> submit() async {
    // form validation
    if (!formKey.currentState!.validate()) {
      return;
    }

    // update state fields
    _setState(signupState.copyWith(isSubmitting: true, clearError: true));

    try {
      final email = emailController.text.trim();
      final password = passwordController.text;

      // api request
      await _authRepository.signUp(email: email, password: password);

      _setState(signupState.copyWith(isSubmitting: false));
    } catch (e) {
      // handle error
      _setState(
        signupState.copyWith(
          isSubmitting: false,
          errorMessage: 'Signup failed. Please try again later.',
        ),
      );
    }
  }

  // when screen is removed, dispose of controllers
  @override
  void dispose() {
    passwordController.removeListener(notifyListeners);
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
