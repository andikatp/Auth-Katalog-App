import 'package:auth_katalog_app/features/auth/application/auth_controller.dart';
import 'package:auth_katalog_app/features/auth/application/auth_state.dart';
import 'package:auth_katalog_app/features/profile/presentation/widgets/profile_detail/profile_address_section.dart';
import 'package:auth_katalog_app/features/profile/presentation/widgets/profile_detail/profile_company_section.dart';
import 'package:auth_katalog_app/features/profile/presentation/widgets/profile_detail/profile_info_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileDetailScreen extends ConsumerWidget {
  const ProfileDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref
        .read(authControllerProvider)
        .when(
          initial: () => null,
          loading: () => null,
          success: (user) => user,
          failure: (_) => null,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Details'),
      ),
      body: user == null
          ? const SizedBox.shrink()
          : SingleChildScrollView(
              padding: const .symmetric(horizontal: 20, vertical: 16),
              child: Column(
                spacing: 16,
                children: [
                  ProfileInfoSection(user: user),
                  if (user.company != null) ...[
                    ProfileCompanySection(company: user.company!),
                  ],
                  if (user.address != null) ...[
                    ProfileAddressSection(address: user.address!),
                  ],
                ],
              ),
            ),
    );
  }
}
