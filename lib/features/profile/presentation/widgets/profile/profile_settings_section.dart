import 'package:auth_katalog_app/core/extensions/build_context_extensions.dart';
import 'package:auth_katalog_app/core/theme/app_theme.dart';
import 'package:auth_katalog_app/features/profile/presentation/widgets/profile/theme_selector_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileSettingsSection extends ConsumerWidget {
  const ProfileSettingsSection({super.key});

  String _getThemeName(ThemeMode mode) {
    return switch (mode) {
      .light => 'Light',
      .dark => 'Dark',
      .system => 'System Default',
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(appThemeProvider);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: .circular(16),
        side: BorderSide(color: context.dividerColor.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const .all(16),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 8,
          children: [
            Text(
              'Preferences',
              style: context.titleMedium.copyWith(fontWeight: .bold),
            ),
            ListTile(
              contentPadding: .zero,
              leading: Container(
                padding: const .all(8),
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.1),
                  borderRadius: .circular(10),
                ),
                child: Icon(
                  Icons.palette_outlined,
                  color: context.primaryColor,
                ),
              ),
              title: const Text(
                'Theme Mode',
                style: TextStyle(fontWeight: .w600),
              ),
              subtitle: Text(_getThemeName(currentTheme)),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => ThemeSelectorModal.show(context),
            ),
          ],
        ),
      ),
    );
  }
}
