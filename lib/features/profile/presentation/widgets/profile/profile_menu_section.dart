import 'dart:async';

import 'package:auth_katalog_app/core/extensions/build_context_extensions.dart';
import 'package:auth_katalog_app/core/theme/app_theme.dart';
import 'package:auth_katalog_app/features/auth/application/auth_controller.dart';
import 'package:auth_katalog_app/features/profile/presentation/widgets/profile/profile_menu_item.dart';
import 'package:auth_katalog_app/features/profile/presentation/widgets/profile/theme_selector_modal.dart';
import 'package:auth_katalog_app/routers/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileMenuSection extends ConsumerWidget {
  const ProfileMenuSection({super.key});

  String _getThemeName(ThemeMode mode) {
    return switch (mode) {
      .light => 'Light',
      .dark => 'Dark',
      .system => 'System Default',
    };
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(authControllerProvider.notifier).logout();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(appThemeProvider);

    final items = [
      ProfileMenuItem(
        icon: Icons.person_outline_rounded,
        title: 'Personal Details',
        subtitle: 'View your full profile & address info',
        onTap: () => const ProfileDetailRoute().push<void>(context),
      ),
      ProfileMenuItem(
        icon: Icons.palette_outlined,
        title: 'Appearance',
        subtitle: _getThemeName(currentTheme),
        onTap: () => ThemeSelectorModal.show(context),
      ),
      ProfileMenuItem(
        icon: Icons.logout_rounded,
        title: 'Log Out',
        subtitle: 'Sign out of your account',
        isDestructive: true,
        onTap: () async => _handleLogout(context, ref),
      ),
    ];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: .circular(16),
        side: BorderSide(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const .all(8),
        child: ListView.separated(
          shrinkWrap: true,
          padding: .zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) =>
              const Divider(height: 1, indent: 16, endIndent: 16),
          itemBuilder: (context, index) => items[index],
        ),
      ),
    );
  }
}
