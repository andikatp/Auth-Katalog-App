import 'package:auth_katalog_app/features/dashboard/application/dashboard_controller.dart';
import 'package:auth_katalog_app/features/dashboard/dashboard_provider.dart';
import 'package:auth_katalog_app/features/dashboard/domain/entities/product.dart';
import 'package:auth_katalog_app/features/dashboard/domain/params/get_products_params.dart';
import 'package:auth_katalog_app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDashboardRepository extends Mock implements DashboardRepository {}

void main() {
  late MockDashboardRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(const GetProductsParams(skip: 0, query: ''));
  });

  setUp(() {
    mockRepository = MockDashboardRepository();
  });

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        dashboardRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('initial state has pages as null', () {
    final container = makeProviderContainer();
    final state = container.read(dashboardControllerProvider);

    expect(state.pagingState.pages, isNull);
    expect(state.pagingState.isLoading, isFalse);
  });

  test('fetchProducts preserves pages as null during initial fetch '
      '(showing skeleton)', () async {
    when(() => mockRepository.getProducts(any())).thenAnswer(
      (_) async => (null, <Product>[]),
    );

    final container = makeProviderContainer();
    final controller = container.read(dashboardControllerProvider.notifier);

    // Initial state before network call completes
    final stateBefore = container.read(dashboardControllerProvider);
    expect(stateBefore.pagingState.pages, isNull);

    await controller.fetchProducts();

    final stateAfter = container.read(dashboardControllerProvider);
    expect(stateAfter.pagingState.pages, isNotNull);
  });
}
