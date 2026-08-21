import 'package:auth_katalog_app/core/network/errors/failure.dart';
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

  const dummyProduct = Product(
    id: 1,
    title: 'Test Product',
    price: 10,
    thumbnail: 'http://test.com/img.png',
  );

  group('DashboardController', () {
    test('initial state has pages as null', () {
      final container = makeProviderContainer();
      final state = container.read(dashboardControllerProvider);

      expect(state.pagingState.pages, isNull);
      expect(state.pagingState.isLoading, equals(false));
      expect(state.searchQuery, equals(''));
    });

    test('fetchProducts updates pagingState with fetched products', () async {
      when(() => mockRepository.getProducts(any())).thenAnswer(
        (_) async => (null, [dummyProduct]),
      );

      final container = makeProviderContainer();
      final controller = container.read(dashboardControllerProvider.notifier);

      await controller.fetchProducts();

      final state = container.read(dashboardControllerProvider);
      expect(state.pagingState.pages, isNotNull);
      expect(state.pagingState.pages!.first, equals([dummyProduct]));
      expect(state.pagingState.isLoading, equals(false));
      verify(() => mockRepository.getProducts(any())).called(1);
    });

    test('fetchProducts handles failure gracefully', () async {
      when(() => mockRepository.getProducts(any())).thenAnswer(
        (_) async => (const ServerFailure('Network error'), null),
      );

      final container = makeProviderContainer();
      final controller = container.read(dashboardControllerProvider.notifier);

      await controller.fetchProducts();

      final state = container.read(dashboardControllerProvider);
      expect(state.pagingState.error, equals('Network error'));
      verify(() => mockRepository.getProducts(any())).called(1);
    });

    test('onSearchChanged updates searchQuery and re-fetches products',
        () async {
      when(() => mockRepository.getProducts(any())).thenAnswer(
        (_) async => (null, [dummyProduct]),
      );

      final container = makeProviderContainer();
      container
          .read(dashboardControllerProvider.notifier)
          .onSearchChanged('mascara');

      final state = container.read(dashboardControllerProvider);
      expect(state.searchQuery, equals('mascara'));
    });

    test('refresh resets pagination state and fetches products', () async {
      when(() => mockRepository.getProducts(any())).thenAnswer(
        (_) async => (null, [dummyProduct]),
      );

      final container = makeProviderContainer();
      final controller = container.read(dashboardControllerProvider.notifier);

      await controller.refresh();

      final state = container.read(dashboardControllerProvider);
      expect(state.pagingState.pages, isNotNull);
      verify(() => mockRepository.getProducts(any())).called(1);
    });
  });
}
