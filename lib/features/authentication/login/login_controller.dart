import 'package:flutter/material.dart';
import 'package:local_fork/features/authentication/authentication_repository.dart';
import 'package:local_fork/features/authentication/login/login_state.dart';

class LoginController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _authRepository = AuthenticationRepository();

  LoginState _loginState = const LoginState();

  // getter
  LoginState get loginState => _loginState;

  // setter
  void _setState(LoginState newLoginState) {
    _loginState = newLoginState;
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
    return null;
  }

  Future<void> submit() async {
    // form validation
    if (!formKey.currentState!.validate()) {
      return;
    }

    // update state fields
    _setState(loginState.copyWith(isSubmitting: true, errorMessage: null));

    try {
      final email = emailController.text.trim();
      final password = passwordController.text;

      // api request
      await _authRepository.logIn(email: email, password: password);

      _setState(loginState.copyWith(isSubmitting: false));
    } catch (e) {
      // handle error
      _setState(
        loginState.copyWith(
          isSubmitting: false,
          errorMessage: 'Invalid email or password',
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
