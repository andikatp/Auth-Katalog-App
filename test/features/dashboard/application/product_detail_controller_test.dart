import 'package:auth_katalog_app/core/network/errors/failure.dart';
import 'package:auth_katalog_app/features/dashboard/application/product_detail_controller.dart';
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

  group('ProductDetailController', () {
    test('build loads product into AsyncValue on repository success', () async {
      when(() => mockRepository.getProductDetail(1)).thenAnswer(
        (_) async => (null, dummyProduct),
      );

      final container = makeProviderContainer()
        ..listen(
          productDetailControllerProvider(1),
          (previous, next) {},
        );

      final state = await container.read(
        productDetailControllerProvider(1).future,
      );

      expect(state.id, equals(1));
      expect(state.title, equals('Test Product'));
      verify(() => mockRepository.getProductDetail(1)).called(1);
    });

    test('build throws error on repository failure', () async {
      when(() => mockRepository.getProductDetail(1)).thenAnswer(
        (_) async => (const ServerFailure('Product not found'), null),
      );

      final container = makeProviderContainer()
        ..listen(
          productDetailControllerProvider(1),
          (previous, next) {},
          fireImmediately: true,
        );

      await pumpEventQueue();

      final state = container.read(productDetailControllerProvider(1));
      expect(state.hasError, isTrue);
      expect(state.error, isA<Exception>());
      verify(() => mockRepository.getProductDetail(1)).called(1);
    });
  });
}
