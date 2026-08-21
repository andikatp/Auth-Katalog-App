import 'package:auth_katalog_app/features/auth/application/auth_controller.dart';
import 'package:auth_katalog_app/features/auth/application/auth_state.dart';
import 'package:auth_katalog_app/features/auth/presentation/widgets/login_form.dart';
import 'package:auth_katalog_app/features/auth/presentation/widgets/login_header.dart';
import 'package:auth_katalog_app/features/core/presentations/widgets/theme_toggle_button.dart';
import 'package:auth_katalog_app/features/core/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(
      authControllerProvider,
      (_, next) {
        next.whenOrNull(
          loading: Loading.show,
          failure: Loading.error,
          success: (_) => Loading.dismiss(),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(actions: const [ThemeToggleButton()]),
      body: const SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: .symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: .center,
              spacing: 28,
              children: [
                LoginHeader(),
                LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
