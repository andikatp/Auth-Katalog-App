import 'package:auth_katalog_app/core/network/errors/failure.dart';
import 'package:auth_katalog_app/features/dashboard/dashboard_provider.dart';
import 'package:auth_katalog_app/features/dashboard/domain/entities/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_detail_controller.g.dart';

@Riverpod(keepAlive: true)
class ProductDetailController extends _$ProductDetailController {
  @override
  Future<Product> build(int productId) async {
    final (failure, product) = await ref
        .read(dashboardRepositoryProvider)
        .getProductDetail(productId);

    if (failure != null) {
      throw Exception(failure.errorMessage);
    }

    return product!;
  }
}
