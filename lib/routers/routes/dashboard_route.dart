part of 'routes.dart';

class DashboardRoute extends GoRouteData with $DashboardRoute {
  const DashboardRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      GoTransitions.slide.toRight
          .copyWith(child: const DashboardScreen())
          .call(context, state);
}
