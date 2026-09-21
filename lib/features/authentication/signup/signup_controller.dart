import 'package:flutter/material.dart';
import 'package:local_fork/features/authentication/authentication_repository.dart';
import 'package:local_fork/features/authentication/signup/signup_state.dart';

class SignupController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _authRepository = AuthenticationRepository();

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
    if (value.length < 10) {
      return "Password must be at least 10 characters.";
    }
    if (!value.contains(RegExp(r"[A-Z]"))) {
      return 'Password must contain at least one uppercase letter.';
    }
    if (!value.contains(RegExp(r"[a-z]"))) {
      return 'Password must contain at least one lowercase letter.';
    }
    if (!value.contains(RegExp(r"[0-9]"))) {
      return 'Password must contain at least one number.';
    }
    if (!value.contains(RegExp(r"[^A-Za-z0-9]"))) {
      return 'Password must contain at least one special character.';
    }
    return null;
  }

  Future<void> submit() async {
    // form validation
    if (!formKey.currentState!.validate()) {
      return;
    }

    // update state fields
    _setState(signupState.copyWith(isSubmitting: true, errorMessage: null));

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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
