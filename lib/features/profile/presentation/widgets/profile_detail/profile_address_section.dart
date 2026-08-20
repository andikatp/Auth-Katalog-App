import 'package:auth_katalog_app/core/extensions/string_extensions.dart';
import 'package:auth_katalog_app/features/auth/domain/entities/user_address.dart';
import 'package:auth_katalog_app/features/profile/presentation/widgets/profile_detail/profile_detail_section.dart';
import 'package:flutter/material.dart';

class ProfileAddressSection extends StatelessWidget {
  const ProfileAddressSection({required this.address, super.key});
  final UserAddress address;

  @override
  Widget build(BuildContext context) {
    return ProfileDetailSection(
      title: 'Address & Location',
      children: [
        ProfileDetailRow(
          icon: Icons.location_on_outlined,
          label: 'Street',
          value: address.address.clean,
        ),
        ProfileDetailRow(
          icon: Icons.map_outlined,
          label: 'City / Region',
          value: address.locationSummary,
        ),
      ],
    );
  }
}
