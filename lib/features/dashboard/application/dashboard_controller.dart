import 'dart:async';

import 'package:auth_katalog_app/core/network/errors/failure.dart';
import 'package:auth_katalog_app/features/dashboard/application/dashboard_state.dart';
import 'package:auth_katalog_app/features/dashboard/dashboard_provider.dart';
import 'package:auth_katalog_app/features/dashboard/domain/params/get_products_params.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_controller.g.dart';

@riverpod
class DashboardController extends _$DashboardController {
  static const _pageSize = 10;

  @override
  DashboardState build() {
    return DashboardState.initial();
  }

  Future<void> fetchProducts() async {
    if (!state.pagingState.hasNextPage) return;
    if (state.pagingState.isLoading) return;

    final currentPages = state.pagingState.pages;
    final currentKeys = state.pagingState.keys;

    final nextSkip = (currentKeys == null || currentKeys.isEmpty)
        ? 0
        : (currentKeys.last + (currentPages?.last.length ?? 0));

    state = state.copyWith(
      pagingState: state.pagingState.copyWith(isLoading: true, error: null),
    );

    final params = GetProductsParams(skip: nextSkip, query: state.searchQuery);

    final (failure, products) = await ref
        .read(dashboardRepositoryProvider)
        .getProducts(params);

    if (failure != null) {
      state = state.copyWith(
        pagingState: PagingState(
          pages: currentPages,
          keys: currentKeys,
          error: failure.errorMessage,
        ),
      );
      return;
    }

    final isLastPage = products!.length < _pageSize;
    final updatedPages = [...?currentPages, products];
    final updatedKeys = [...?currentKeys, nextSkip];

    state = state.copyWith(
      pagingState: PagingState(
        pages: updatedPages,
        keys: updatedKeys,
        hasNextPage: !isLastPage,
      ),
    );
  }

  void onSearchChanged(String query) {
    if (state.searchQuery == query) return;
    state = DashboardState.initial().copyWith(searchQuery: query);
    unawaited(fetchProducts());
  }

  Future<void> refresh() async {
    state = DashboardState.initial().copyWith(searchQuery: state.searchQuery);
    await fetchProducts();
  }
}
