import 'package:auth_katalog_app/features/dashboard/domain/entities/product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part 'dashboard_state.freezed.dart';

@freezed
sealed class DashboardState with _$DashboardState {
  const factory DashboardState({
    required PagingState<int, Product> pagingState,
    @Default('') String searchQuery,
  }) = _DashboardState;

  factory DashboardState.initial() =>
      DashboardState(pagingState: PagingState<int, Product>());
}
