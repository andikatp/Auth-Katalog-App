import 'package:auth_katalog_app/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

class ProfileDetailSection extends StatelessWidget {
  const ProfileDetailSection({
    required this.title,
    required this.children,
    super.key,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const .all(16),
        child: Column(
          spacing: 12,
          crossAxisAlignment: .start,
          children: [
            Text(
              title,
              style: context.titleMedium.copyWith(fontWeight: .bold),
            ),
            ListView.separated(
              shrinkWrap: true,
              padding: .zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: children.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) => children[index],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  const ProfileDetailRow({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(vertical: 8),
      child: Row(
        spacing: 12,
        crossAxisAlignment: .start,
        children: [
          Icon(icon, size: 20, color: context.primaryColor),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: context.bodyMedium.copyWith(color: context.hintColor),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: .end,
              style: context.bodyMedium.copyWith(fontWeight: .w600),
            ),
          ),
        ],
      ),
    );
  }
}
