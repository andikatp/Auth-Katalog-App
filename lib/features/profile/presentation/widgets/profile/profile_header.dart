import 'package:auth_katalog_app/core/extensions/build_context_extensions.dart';
import 'package:auth_katalog_app/core/extensions/string_extensions.dart';
import 'package:auth_katalog_app/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({required this.user, super.key});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: .center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: .circle,
                border: .all(color: context.primaryColor, width: 3),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: context.primaryColor.withValues(alpha: 0.1),
                backgroundImage: user.image.isNotEmpty
                    ? NetworkImage(user.image)
                    : null,
                child: user.image.isEmpty
                    ? Text(
                        user.initials,
                        style: context.headlineLarge.copyWith(
                          color: context.primaryColor,
                          fontWeight: .bold,
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          user.fullName,
          textAlign: .center,
          style: context.titleLarge.copyWith(fontWeight: .bold),
        ),
        const SizedBox(height: 4),
        Text(
          user.handle,
          style: context.bodyMedium.copyWith(color: context.hintColor),
        ),
        if (user.formattedRole != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const .symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.15),
              borderRadius: .circular(20),
            ),
            child: Text(
              user.formattedRole.clean,
              style: context.labelSmall.copyWith(color: context.primaryColor),
            ),
          ),
        ],
      ],
    );
  }
}
