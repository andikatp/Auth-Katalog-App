part of 'routes.dart';

class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      GoTransitions.slide.toLeft
          .copyWith(child: const ProfileScreen())
          .call(context, state);
}
