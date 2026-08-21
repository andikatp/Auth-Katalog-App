import 'package:auth_katalog_app/core/network/errors/failure.dart';
import 'package:auth_katalog_app/core/providers/network_info.dart';
import 'package:auth_katalog_app/features/dashboard/domain/entities/product.dart';
import 'package:auth_katalog_app/features/dashboard/domain/params/get_products_params.dart';
import 'package:auth_katalog_app/features/dashboard/infrastructure/datasources/dashboard_remote_data_source.dart';
import 'package:auth_katalog_app/features/dashboard/infrastructure/repositories/dashboard_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDashboardRemoteDataSource extends Mock
    implements DashboardRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockDashboardRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late DashboardRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const GetProductsParams(skip: 0));
  });

  setUp(() {
    mockRemoteDataSource = MockDashboardRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = DashboardRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );

    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
  });

  const dummyProduct = Product(
    id: 1,
    title: 'Test Product',
    price: 10,
    thumbnail: 'http://test.com/img.png',
  );

  group('DashboardRepositoryImpl', () {
    test('getProducts returns (null, list) on remote success', () async {
      const params = GetProductsParams(skip: 0);
      when(() => mockRemoteDataSource.getProducts(params))
          .thenAnswer((_) async => [dummyProduct]);

      final (failure, products) = await repository.getProducts(params);

      expect(failure, isNull);
      expect(products, equals([dummyProduct]));
      verify(() => mockRemoteDataSource.getProducts(params)).called(1);
    });

    test('getProducts returns (failure, null) when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      const params = GetProductsParams(skip: 0);

      final (failure, products) = await repository.getProducts(params);

      expect(failure, isA<InternetFailure>());
      expect(products, isNull);
      verifyNever(() => mockRemoteDataSource.getProducts(params));
    });

    test('getProductDetail returns (null, product) on success', () async {
      when(() => mockRemoteDataSource.getProductDetail(1))
          .thenAnswer((_) async => dummyProduct);

      final (failure, product) = await repository.getProductDetail(1);

      expect(failure, isNull);
      expect(product, equals(dummyProduct));
      verify(() => mockRemoteDataSource.getProductDetail(1)).called(1);
    });
  });
}
