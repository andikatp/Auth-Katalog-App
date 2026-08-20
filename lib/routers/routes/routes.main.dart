part of 'routes.dart';

@TypedGoRoute<SplashRoute>(path: '/')
class SplashRoute extends GoRouteData with $SplashRoute {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SplashScreen();
}
