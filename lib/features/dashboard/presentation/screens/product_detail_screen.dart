import 'package:auth_katalog_app/features/core/presentations/widgets/app_error_widget.dart';
import 'package:auth_katalog_app/features/dashboard/application/product_detail_controller.dart';
import 'package:auth_katalog_app/features/dashboard/domain/entities/product.dart';
import 'package:auth_katalog_app/features/dashboard/presentation/widgets/product/product_detail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailControllerProvider(id));

    return productAsync.when(
      data: (product) => Scaffold(body: ProductDetailContent(product: product)),
      loading: () => Scaffold(
        body: Skeletonizer(
          child: ProductDetailContent(product: Product.skeleton()),
        ),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Detail Produk')),
        body: AppErrorWidget(
          title: 'Gagal memuat detail produk',
          message: error.toString().replaceAll('Exception: ', ''),
          onRetry: () => ref.refresh(productDetailControllerProvider(id)),
        ),
      ),
    );
  }
}
