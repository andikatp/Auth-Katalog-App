import 'package:auth_katalog_app/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: const .all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: .circular(12),
          ),
          child: Icon(
            Icons.lock_person_rounded,
            size: 40,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Welcome Back',
          textAlign: .center,
          style: context.headlineSmall.copyWith(
            fontWeight: .bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Sign in to continue to your account',
          textAlign: .center,
          style: context.bodyMedium.copyWith(
            color: theme.hintColor,
          ),
        ),
      ],
    );
  }
}
