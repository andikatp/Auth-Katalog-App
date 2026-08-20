import 'package:auth_katalog_app/core/extensions/string_extensions.dart';
import 'package:auth_katalog_app/features/auth/domain/entities/user_company.dart';
import 'package:auth_katalog_app/features/profile/presentation/widgets/profile_detail/profile_detail_section.dart';
import 'package:flutter/material.dart';

class ProfileCompanySection extends StatelessWidget {
  const ProfileCompanySection({required this.company, super.key});
  final UserCompany company;

  @override
  Widget build(BuildContext context) {
    return ProfileDetailSection(
      title: 'Company & Position',
      children: [
        ProfileDetailRow(
          icon: Icons.business_outlined,
          label: 'Company',
          value: company.name.clean,
        ),
        ProfileDetailRow(
          icon: Icons.work_outline,
          label: 'Title',
          value: company.title.clean,
        ),
        ProfileDetailRow(
          icon: Icons.domain_outlined,
          label: 'Department',
          value: company.department.clean,
        ),
      ],
    );
  }
}
