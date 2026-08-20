import 'package:auth_katalog_app/routers/app_route_paths.dart';
import 'package:auth_katalog_app/routers/app_route_redirect.dart';
import 'package:auth_katalog_app/routers/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final router = GoRouter(
    initialLocation: AppRoutePaths.splash,
    debugLogDiagnostics: true,
    routes: $appRoutes,
    redirect: (context, state) =>
        AppRouteRedirect.redirect(context, state, ref),
  );

  return router;
}
