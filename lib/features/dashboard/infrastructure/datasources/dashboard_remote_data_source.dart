import 'package:auth_katalog_app/features/dashboard/domain/entities/product.dart';
import 'package:auth_katalog_app/features/dashboard/domain/params/get_products_params.dart';
import 'package:dio/dio.dart';

abstract class DashboardRemoteDataSource {
  const DashboardRemoteDataSource();

  Future<List<Product>> getProducts(GetProductsParams params);
  Future<Product> getProductDetail(int id);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  DashboardRemoteDataSourceImpl({required this.dio});
  final Dio dio;

  @override
  Future<List<Product>> getProducts(GetProductsParams params) async {
    final query = params.query;
    final hasQuery = query != null && query.trim().isNotEmpty;
    final path = hasQuery ? '/products/search' : '/products';
    final queryParameters = <String, dynamic>{
      'limit': params.limit,
      'skip': params.skip,
      if (hasQuery) 'q': query.trim(),
    };

    final res = await dio.get<Map<String, dynamic>>(
      path,
      queryParameters: queryParameters,
    );

    final data = res.data!;
    final productsRaw = data['products'] as List<dynamic>? ?? [];
    return productsRaw
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Product> getProductDetail(int id) async {
    final res = await dio.get<Map<String, dynamic>>('/products/$id');
    return Product.fromJson(res.data!);
  }
}
