part of 'routes.dart';

@TypedGoRoute<SplashRoute>(path: '/')
class SplashRoute extends GoRouteData with $SplashRoute {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SplashScreen();
}

@TypedShellRoute<HomeShellRoute>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<DashboardRoute>(path: AppRoutePaths.dashboard),
    TypedGoRoute<ProfileRoute>(path: AppRoutePaths.profile),
  ],
)
class HomeShellRoute extends ShellRouteData {
  const HomeShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return BottomNavigation(child: navigator);
  }
}
