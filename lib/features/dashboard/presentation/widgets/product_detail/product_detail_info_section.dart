import 'package:auth_katalog_app/core/extensions/build_context_extensions.dart';
import 'package:auth_katalog_app/features/dashboard/domain/entities/product.dart';
import 'package:auth_katalog_app/features/dashboard/presentation/widgets/product_detail/product_detail_description.dart';
import 'package:auth_katalog_app/features/dashboard/presentation/widgets/product_detail/product_detail_header_chips.dart';
import 'package:auth_katalog_app/features/dashboard/presentation/widgets/product_detail/product_detail_price_widget.dart';
import 'package:auth_katalog_app/features/dashboard/presentation/widgets/product_detail/product_detail_rating_widget.dart';
import 'package:auth_katalog_app/features/dashboard/presentation/widgets/product_detail/product_detail_spec_grid.dart';
import 'package:auth_katalog_app/features/dashboard/presentation/widgets/product_detail/product_detail_tags.dart';
import 'package:flutter/material.dart';

class ProductDetailInfoSection extends StatelessWidget {
  const ProductDetailInfoSection({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .all(16),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 16,
        children: [
          Column(
            crossAxisAlignment: .start,
            spacing: 8,
            children: [
              ProductDetailHeaderChips(product: product),
              Text(
                product.title,
                style: context.titleLarge.copyWith(fontWeight: .bold),
              ),
              ProductDetailRatingWidget(product: product),
            ],
          ),
          ProductDetailPriceWidget(price: product.price),
          const Divider(),
          Column(
            crossAxisAlignment: .start,
            spacing: 12,
            children: [
              Text(
                'Spesifikasi Produk',
                style: context.titleMedium.copyWith(fontWeight: .bold),
              ),
              ProductDetailSpecGrid(product: product),
            ],
          ),
          const Divider(),
          ProductDetailDescription(description: product.description),
          if (product.tags != null && product.tags!.isNotEmpty)
            ProductDetailTags(tags: product.tags!),
        ],
      ),
    );
  }
}
