import 'package:flutter/material.dart';
import 'package:local_fork/core/theme/app_spacing.dart';
import 'package:local_fork/core/util/internal_link.dart';
import 'package:local_fork/core/util/logo.dart';
import 'package:local_fork/core/util/overall_padding.dart';
import 'package:local_fork/features/authentication/login/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginController loginController;

  @override
  void initState() {
    super.initState();
    loginController = LoginController();
    loginController.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    loginController.removeListener(_refresh);
    loginController.dispose();
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
                  key: loginController.formKey,
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
                            'Welcome Back',
                            style: textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          TextFormField(
                            controller: loginController.emailController,
                            validator: loginController.validateEmail,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(labelText: 'Email'),
                            style: textTheme.bodyMedium,
                          ),
                          const SizedBox(height: AppSpacing.m),
                          TextFormField(
                            controller: loginController.passwordController,
                            validator: loginController.validatePassword,
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            style: textTheme.bodyMedium,
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          ElevatedButton(
                            onPressed: loginController.loginState.isSubmitting
                                ? null
                                : loginController.submit,
                            child: loginController.loginState.isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Log In'),
                          ),
                          if (loginController.loginState.errorMessage !=
                              null) ...[
                            const SizedBox(height: AppSpacing.s),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.s,
                              ),
                              child: Text(
                                loginController.loginState.errorMessage!,
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
                                const TextSpan(text: "Don't have an account? "),
                                WidgetSpan(
                                  child: InternalLink(
                                    text: 'Sign up',
                                    onTap: () => Navigator.of(context).pop(),
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
