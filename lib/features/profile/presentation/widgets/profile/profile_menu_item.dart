import 'package:auth_katalog_app/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? context.errorColor : context.primaryColor;

    return ListTile(
      leading: Container(
        padding: const .all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: .circular(10),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: .w600,
          color: isDestructive ? color : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: isDestructive ? null : const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
