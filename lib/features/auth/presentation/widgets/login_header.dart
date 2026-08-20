import 'package:auth_katalog_app/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      spacing: 6,
      children: [
        Text(
          'Welcome Back',
          textAlign: .center,
          style: context.headlineLarge.copyWith(
            fontWeight: .bold,
            fontSize: 38,
          ),
        ),
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
