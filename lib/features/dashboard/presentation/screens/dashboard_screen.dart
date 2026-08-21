import 'package:auth_katalog_app/core/extensions/build_context_extensions.dart';
import 'package:auth_katalog_app/features/core/presentations/widgets/app_error_widget.dart';
import 'package:auth_katalog_app/features/dashboard/application/dashboard_controller.dart';
import 'package:auth_katalog_app/features/dashboard/domain/entities/product.dart';
import 'package:auth_katalog_app/features/dashboard/presentation/widgets/product/product_card.dart';
import 'package:auth_katalog_app/features/dashboard/presentation/widgets/product/product_empty_widget.dart';
import 'package:auth_katalog_app/features/dashboard/presentation/widgets/product/product_search_bar.dart';
import 'package:auth_katalog_app/features/dashboard/presentation/widgets/product/product_skeleton_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardControllerProvider);
    final controller = ref.read(dashboardControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: ProductSearchBar(
          initialQuery: dashboardState.searchQuery,
          onSearchChanged: controller.onSearchChanged,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: PagedGridView<int, Product>(
          state: dashboardState.pagingState,
          fetchNextPage: controller.fetchProducts,
          padding: const .fromLTRB(16, 12, 16, 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          builderDelegate: PagedChildBuilderDelegate<Product>(
            itemBuilder: (context, item, index) => ProductCard(product: item),
            firstPageProgressIndicatorBuilder: (context) =>
                const ProductSkeletonGrid(),
            newPageProgressIndicatorBuilder: (context) => const Padding(
              padding: .all(16),
              child: Center(child: CircularProgressIndicator.adaptive()),
            ),
            noItemsFoundIndicatorBuilder: (context) =>
                const ProductEmptyWidget(),
            firstPageErrorIndicatorBuilder: (context) => AppErrorWidget(
              message:
                  dashboardState.pagingState.error?.toString() ??
                  'Gagal memuat produk',
              onRetry: controller.refresh,
            ),
            newPageErrorIndicatorBuilder: (context) => Padding(
              padding: const .all(16),
              child: Center(
                child: Column(
                  mainAxisSize: .min,
                  spacing: 8,
                  children: [
                    Text(
                      dashboardState.pagingState.error?.toString() ??
                          'Gagal memuat lebih banyak produk',
                      style: context.bodySmall,
                    ),
                    TextButton(
                      onPressed: controller.fetchProducts,
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
