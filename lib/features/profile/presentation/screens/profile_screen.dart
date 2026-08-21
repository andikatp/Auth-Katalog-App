import 'package:auth_katalog_app/features/auth/application/auth_controller.dart';
import 'package:auth_katalog_app/features/auth/application/auth_state.dart';
import 'package:auth_katalog_app/features/auth/domain/entities/user.dart';
import 'package:auth_katalog_app/features/core/presentations/widgets/app_error_widget.dart';
import 'package:auth_katalog_app/features/profile/presentation/widgets/profile/profile_header.dart';
import 'package:auth_katalog_app/features/profile/presentation/widgets/profile/profile_menu_section.dart';
import 'package:auth_katalog_app/features/profile/presentation/widgets/profile/theme_selector_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(authControllerProvider.notifier).checkAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Profile',
            onPressed: () async =>
                ref.read(authControllerProvider.notifier).checkAuth(),
          ),
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Change Theme',
            onPressed: () => ThemeSelectorModal.show(context),
          ),
        ],
      ),
      body: authState.when(
        initial: _buildSkeletonLoader,
        loading: _buildSkeletonLoader,
        failure: (message) => AppErrorWidget(
          title: 'Failed to load profile',
          message: message,
          onRetry: () async =>
              ref.read(authControllerProvider.notifier).checkAuth(),
        ),
        success: (user) {
          if (user == null) return const SizedBox.shrink();
          return ProfileContent(user: user);
        },
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Skeletonizer(
      child: ProfileContent(user: User.skeleton()),
    );
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({required this.user, super.key});
  final User user;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        spacing: 28,
        children: [
          ProfileHeader(user: user),
          const ProfileMenuSection(),
        ],
      ),
    );
  }
}
