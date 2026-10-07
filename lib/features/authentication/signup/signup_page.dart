import 'package:flutter/material.dart';
import 'package:local_fork/core/theme/app_spacing.dart';
import 'package:local_fork/core/util/internal_link.dart';
import 'package:local_fork/core/util/logo.dart';
import 'package:local_fork/core/util/overall_padding.dart';
import 'package:local_fork/features/authentication/signup/signup_controller.dart';
import 'package:local_fork/features/authentication/login/login_page.dart';
import 'package:local_fork/features/authentication/signup/password_checklist.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, required this.title});

  final String title;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late final SignupController signupController;

  @override
  void initState() {
    super.initState();
    signupController = SignupController();
    signupController.addListener(_refresh);
  }

  // rebuild widget without changing state
  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  // remove listener and dispose of controllers when page is removed
  @override
  void dispose() {
    signupController.removeListener(_refresh);
    signupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: OverallPadding(
                child: Form(
                  key: signupController.formKey,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.m),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(child: Logo(radius: 100)),
                          Text(
                            'Create Account',
                            style: textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          TextFormField(
                            controller: signupController.emailController,
                            validator: signupController.validateEmail,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(labelText: 'Email'),
                            style: textTheme.bodyMedium,
                          ),
                          const SizedBox(height: AppSpacing.m),
                          TextFormField(
                            controller: signupController.passwordController,
                            validator: signupController.validatePassword,
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            style: textTheme.bodyMedium,
                          ),
                          const SizedBox(height: AppSpacing.s),
                          PasswordChecklist(
                            password: signupController.password,
                          ),
                          const SizedBox(height: AppSpacing.m),
                          TextFormField(
                            controller:
                                signupController.confirmPasswordController,
                            validator: signupController.validateConfirmPassword,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                            ),
                            obscureText: true,
                            style: textTheme.bodyMedium,
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          ElevatedButton(
                            onPressed: signupController.signupState.isSubmitting
                                ? null
                                : signupController.submit,
                            child: signupController.signupState.isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Sign Up'),
                          ),
                          if (signupController.signupState.errorMessage !=
                              null) ...[
                            const SizedBox(height: AppSpacing.s),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.s,
                              ),
                              child: Text(
                                signupController.signupState.errorMessage!,
                                style: TextStyle(color: colorScheme.error),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.s),
                          ],
                          const SizedBox(height: AppSpacing.l),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: textTheme.bodySmall,
                              children: [
                                const TextSpan(
                                  text: 'Already have an account? ',
                                ),
                                WidgetSpan(
                                  child: InternalLink(
                                    text: 'Login',
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => const LoginPage(),
                                      ),
                                    ),
                                  ),
                                ),
                                const TextSpan(text: ' instead'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
