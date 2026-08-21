import 'package:auth_katalog_app/features/dashboard/domain/params/get_products_params.dart';
import 'package:auth_katalog_app/features/dashboard/infrastructure/datasources/dashboard_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late DashboardRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = DashboardRemoteDataSourceImpl(dio: mockDio);
  });

  final dummyProductsJson = jsonFixture('products.json');
  final dummyProductDetailJson = jsonFixture('product_detail.json');

  group('DashboardRemoteDataSource', () {
    test('getProducts calls /products when query is null or empty', () async {
      const params = GetProductsParams(skip: 0);

      final response = Response<Map<String, dynamic>>(
        data: dummyProductsJson,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/products'),
      );

      when(
        () => mockDio.get<Map<String, dynamic>>(
          '/products',
          queryParameters: <String, dynamic>{'limit': 10, 'skip': 0},
        ),
      ).thenAnswer((_) async => response);

      final products = await dataSource.getProducts(params);

      expect(products.length, equals(1));
      expect(products.first.id, equals(1));
      expect(products.first.title, equals('Essence Mascara Lash Princess'));
      verify(
        () => mockDio.get<Map<String, dynamic>>(
          '/products',
          queryParameters: <String, dynamic>{'limit': 10, 'skip': 0},
        ),
      ).called(1);
    });

    test('getProducts calls /products/search when query is provided', () async {
      const params = GetProductsParams(skip: 0, query: 'mascara');

      final response = Response<Map<String, dynamic>>(
        data: dummyProductsJson,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/products/search'),
      );

      when(
        () => mockDio.get<Map<String, dynamic>>(
          '/products/search',
          queryParameters: <String, dynamic>{
            'limit': 10,
            'skip': 0,
            'q': 'mascara',
          },
        ),
      ).thenAnswer((_) async => response);

      final products = await dataSource.getProducts(params);

      expect(products.length, equals(1));
      expect(products.first.id, equals(1));
      verify(
        () => mockDio.get<Map<String, dynamic>>(
          '/products/search',
          queryParameters: <String, dynamic>{
            'limit': 10,
            'skip': 0,
            'q': 'mascara',
          },
        ),
      ).called(1);
    });

    test('getProductDetail calls /products/1 and returns Product', () async {
      final response = Response<Map<String, dynamic>>(
        data: dummyProductDetailJson,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/products/1'),
      );

      when(
        () => mockDio.get<Map<String, dynamic>>('/products/1'),
      ).thenAnswer((_) async => response);

      final product = await dataSource.getProductDetail(1);

      expect(product.id, equals(1));
      expect(product.description, equals('A great mascara.'));
      verify(() => mockDio.get<Map<String, dynamic>>('/products/1')).called(1);
    });
  });
}
