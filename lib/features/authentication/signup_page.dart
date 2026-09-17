import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_fork/core/util/internal_link.dart';
import 'package:local_fork/core/util/overall_padding.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, required this.title});

  final String title;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return OverallPadding(
      child: Center(
        child: Card(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Center(child: SvgPicture.asset('assets/logo.svg')),
              Text(
                'Create Account',
                style: TextStyle(fontSize: textTheme.titleLarge?.fontSize),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
                style: TextStyle(fontSize: textTheme.bodyMedium?.fontSize),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              ElevatedButton(onPressed: () {}, child: const Text('Sign Up')),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: textTheme.bodySmall?.fontSize),
                  children: [
                    const TextSpan(text: 'Already have an account? '),
                    WidgetSpan(
                      child: InternalLink(text: 'Login', onTap: () {}),
                    ),
                    const TextSpan(text: ' instead'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
