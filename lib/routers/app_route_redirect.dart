import 'package:auth_katalog_app/features/auth/application/auth_controller.dart';
import 'package:auth_katalog_app/features/auth/application/auth_state.dart';
import 'package:auth_katalog_app/routers/app_route_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class AppRouteRedirect {
  const AppRouteRedirect._();

  static String? redirect(
    BuildContext context,
    GoRouterState state,
    Ref ref,
  ) {
    final authState = ref.read(authControllerProvider);

    final currentLocation = state.matchedLocation;
    final isSplash = currentLocation == AppRoutePaths.splash;
    final isLogin = currentLocation == AppRoutePaths.login;

    return authState.when(
      initial: () => null,
      loading: () => null,
      failure: (_) {
        if (isLogin) return null;
        return AppRoutePaths.login;
      },
      success: (_) {
        if (isSplash || isLogin) {
          return AppRoutePaths.dashboard;
        }
        return null;
      },
    );
  }
}
