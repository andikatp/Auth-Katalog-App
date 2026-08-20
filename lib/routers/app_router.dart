import 'package:auth_katalog_app/features/auth/application/auth_controller.dart';
import 'package:auth_katalog_app/features/auth/application/auth_state.dart';
import 'package:auth_katalog_app/routers/app_route_paths.dart';
import 'package:auth_katalog_app/routers/app_route_redirect.dart';
import 'package:auth_katalog_app/routers/routes/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final refreshNotifier = ValueNotifier<AuthState>(const AuthState.initial());

  ref
    ..listen<AuthState>(
      authControllerProvider,
      (_, next) => refreshNotifier.value = next,
    )
    ..onDispose(refreshNotifier.dispose);

  final router = GoRouter(
    initialLocation: AppRoutePaths.splash,
    debugLogDiagnostics: true,
    routes: $appRoutes,
    refreshListenable: refreshNotifier,
    redirect: (context, state) =>
        AppRouteRedirect.redirect(context, state, ref),
  );

  return router;
}
