part of 'routes.dart';

@TypedGoRoute<DashboardRoute>(path: AppRoutePaths.dashboard)
class DashboardRoute extends GoRouteData with $DashboardRoute {
  const DashboardRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DashboardScreen();
}
