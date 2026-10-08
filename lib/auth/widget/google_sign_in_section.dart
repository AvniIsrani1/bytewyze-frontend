import 'package:flutter/material.dart';
import 'package:local_fork/auth/service/google_auth_service.dart';
import 'package:local_fork/core/theme/app_spacing.dart';

// "or" divider followed by the Google sign-in box, shared by login and signup
class GoogleSignInSection extends StatelessWidget {
  const GoogleSignInSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
              child: Text('or', style: textTheme.bodySmall),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: AppSpacing.m),
        GestureDetector(
          onTap: () => handleGoogleSignIn(context),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.m),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.secondary, width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Google logo; the URL goes in quotes, Image.network takes it as a string
                Image.network(
                  'https://www.citypng.com/public/uploads/preview/google-logo-icon-gsuite-hd-701751694791470gzbayltphh.png',
                  height: 20,
                  width: 20,
                ),
                const SizedBox(width: AppSpacing.m),
                Text(
                  'Continue with Google',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
