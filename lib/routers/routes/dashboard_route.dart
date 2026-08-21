part of 'routes.dart';

class DashboardRoute extends GoRouteData with $DashboardRoute {
  const DashboardRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      GoTransitions.slide.toRight
          .copyWith(child: const DashboardScreen())
          .call(context, state);
}

@TypedGoRoute<ProductDetailRoute>(path: AppRoutePaths.productDetail)
class ProductDetailRoute extends GoRouteData with $ProductDetailRoute {
  const ProductDetailRoute({required this.id});
  final int id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      GoTransitions.slide.toLeft
          .copyWith(child: ProductDetailScreen(id: id))
          .call(context, state);
}
