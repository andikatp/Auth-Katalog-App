import 'dart:async';

import 'package:auth_katalog_app/core/extensions/build_context_extensions.dart';
import 'package:auth_katalog_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeSelectorModal extends ConsumerWidget {
  const ThemeSelectorModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(20)),
      ),
      builder: (context) => const ThemeSelectorModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(appThemeProvider);

    final themes = [
      (
        mode: ThemeMode.light,
        title: 'Light Theme',
        subtitle: 'Bright & clean default look',
        icon: Icons.light_mode_outlined,
      ),
      (
        mode: ThemeMode.dark,
        title: 'Dark Theme',
        subtitle: 'Sleek & high contrast dark look',
        icon: Icons.dark_mode_outlined,
      ),
      (
        mode: ThemeMode.system,
        title: 'System Default',
        subtitle: 'Matches your device settings',
        icon: Icons.brightness_auto_outlined,
      ),
    ];

    return SafeArea(
      child: Padding(
        padding: const .symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.dividerColor,
                  borderRadius: .circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const .symmetric(horizontal: 8),
              child: Text(
                'Appearance',
                style: context.titleLarge.copyWith(fontWeight: .bold),
              ),
            ),
            const SizedBox(height: 12),
            ...themes.map((t) {
              final isSelected = currentTheme == t.mode;

              return ListTile(
                shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                leading: Icon(
                  t.icon,
                  color: isSelected
                      ? context.primaryColor
                      : context.theme.iconTheme.color,
                ),
                title: Text(
                  t.title,
                  style: TextStyle(fontWeight: isSelected ? .bold : .normal),
                ),
                subtitle: Text(t.subtitle),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle_rounded,
                        color: context.primaryColor,
                      )
                    : null,
                onTap: () {
                  unawaited(
                    ref.read(appThemeProvider.notifier).changeTheme(t.mode),
                  );
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
