import 'package:auth_katalog_app/core/utils/typedef.dart';
import 'package:auth_katalog_app/features/dashboard/domain/entities/product.dart';
import 'package:auth_katalog_app/features/dashboard/domain/params/get_products_params.dart';

abstract class DashboardRepository {
  const DashboardRepository();

  ResultFuture<List<Product>> getProducts(GetProductsParams params);
}
