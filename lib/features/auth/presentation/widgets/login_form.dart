import 'package:auth_katalog_app/core/extensions/build_context_extensions.dart';
import 'package:auth_katalog_app/features/auth/application/auth_controller.dart';
import 'package:auth_katalog_app/features/auth/domain/params/login_params.dart';
import 'package:auth_katalog_app/features/auth/domain/validators/auth_validator.dart';
import 'package:auth_katalog_app/features/auth/presentation/widgets/login_button.dart';
import 'package:auth_katalog_app/features/core/presentations/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int _selectedExpiresInMins = 1;
  bool _obscurePassword = true;

  final List<int> _allowedExpiresInMins = const [1, 5, 10, 30, 60];

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final params = LoginParams(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      expiresInMins: _selectedExpiresInMins,
    );
    await ref.read(authControllerProvider.notifier).login(params);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 16,
        crossAxisAlignment: .stretch,
        children: [
          CustomTextField(
            title: 'Username',
            controller: _usernameController,
            hintText: 'Enter your username',
            prefixIcon: const Icon(Icons.person_outline_rounded),
            textInputAction: .next,
            validator: AuthValidator.validateUsername,
          ),
          CustomTextField(
            title: 'Password',
            controller: _passwordController,
            hintText: 'Enter your password',
            obscureText: _obscurePassword,
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
            textInputAction: .done,
            onFieldSubmitted: (_) => _handleLogin(),
            validator: AuthValidator.validatePassword,
          ),
          Column(
            crossAxisAlignment: .start,
            spacing: 6,
            children: [
              Text(
                'Session Expiration',
                style: context.bodyMedium.copyWith(fontWeight: .w600),
              ),
              DropdownButtonFormField<int>(
                initialValue: _selectedExpiresInMins,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.timer_outlined),
                ),
                items: _allowedExpiresInMins.map((value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value minutes'),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue == null) return;
                  setState(() => _selectedExpiresInMins = newValue);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          LoginButton(onPressed: _handleLogin),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
