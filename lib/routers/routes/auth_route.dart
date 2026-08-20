part of 'routes.dart';

@TypedGoRoute<LoginRoute>(path: AppRoutePaths.login)
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LoginScreen();
}
