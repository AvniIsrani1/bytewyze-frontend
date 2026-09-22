import 'package:flutter/material.dart';
import 'package:local_fork/core/theme/app_spacing.dart';
import 'package:local_fork/features/authentication/signup/password_requirement.dart';
import 'package:local_fork/core/theme/app_colors.dart';

class PasswordChecklist extends StatelessWidget {
  final String password;

  const PasswordChecklist({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final pendingColor = Theme.of(context).colorScheme.onSurfaceVariant;
    final successColor = context.appColors.success;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: PasswordRequirement.all.map((requirement) {
        final isMet = requirement.isSatisfied(password);
        final color = isMet ? successColor : pendingColor;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Semantics(
            label: '${requirement.label}: ${isMet ? "met" : "not met"}',
            excludeSemantics: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isMet ? Icons.check_circle : Icons.circle_outlined,
                  size: 16,
                  color: color,
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: Text(
                    requirement.label,
                    style: textTheme.bodySmall?.copyWith(color: color),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  
  }
}
