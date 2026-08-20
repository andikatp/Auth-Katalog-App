import 'package:auth_katalog_app/core/extensions/string_extensions.dart';
import 'package:auth_katalog_app/features/auth/domain/entities/user.dart';
import 'package:auth_katalog_app/features/profile/presentation/widgets/profile_detail/profile_detail_section.dart';
import 'package:flutter/material.dart';

class ProfileInfoSection extends StatelessWidget {
  const ProfileInfoSection({required this.user, super.key});
  final User user;

  @override
  Widget build(BuildContext context) {
    return ProfileDetailSection(
      title: 'Personal Details',
      children: [
        ProfileDetailRow(
          icon: Icons.email_outlined,
          label: 'Email',
          value: user.email.clean,
        ),
        ProfileDetailRow(
          icon: Icons.phone_outlined,
          label: 'Phone',
          value: user.phone.clean,
        ),
        ProfileDetailRow(
          icon: Icons.person_outline,
          label: 'Gender',
          value: user.gender.clean,
        ),
        ProfileDetailRow(
          icon: Icons.cake_outlined,
          label: 'Birth Date',
          value: user.birthDate.readableDate,
        ),
      ],
    );
  }
}
