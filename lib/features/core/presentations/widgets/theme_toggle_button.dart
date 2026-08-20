import 'package:auth_katalog_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(appThemeProvider);
    final isDark = currentTheme == ThemeMode.dark;

    return IconButton(
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
      tooltip: 'Toggle Theme',
      onPressed: () async {
        final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
        await ref.read(appThemeProvider.notifier).changeTheme(newMode);
      },
    );
  }
}
