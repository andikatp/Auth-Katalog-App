import 'package:auth_katalog_app/core/network/core/result.dart';
import 'package:auth_katalog_app/core/network/core/safe_call.dart';
import 'package:auth_katalog_app/core/providers/network_info.dart';
import 'package:auth_katalog_app/core/utils/typedef.dart';
import 'package:auth_katalog_app/features/dashboard/domain/entities/product.dart';
import 'package:auth_katalog_app/features/dashboard/domain/params/get_products_params.dart';
import 'package:auth_katalog_app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:auth_katalog_app/features/dashboard/infrastructure/datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
  final DashboardRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  @override
  ResultFuture<List<Product>> getProducts(GetProductsParams params) async {
    final result = await safeCall(
      () => remoteDataSource.getProducts(params),
      networkInfo: networkInfo,
    );

    return switch (result) {
      Success(:final data) => (null, data),
      ResultFailure(:final failure) => (failure, null),
    };
  }

  @override
  ResultFuture<Product> getProductDetail(int id) async {
    final result = await safeCall(
      () => remoteDataSource.getProductDetail(id),
      networkInfo: networkInfo,
    );

    return switch (result) {
      Success(:final data) => (null, data),
      ResultFailure(:final failure) => (failure, null),
    };
  }
}
