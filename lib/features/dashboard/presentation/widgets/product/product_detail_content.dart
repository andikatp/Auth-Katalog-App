import 'package:auth_katalog_app/features/dashboard/domain/entities/product.dart';
import 'package:auth_katalog_app/features/dashboard/presentation/widgets/product_detail/product_detail_bottom_bar.dart';
import 'package:auth_katalog_app/features/dashboard/presentation/widgets/product_detail/product_detail_image_gallery.dart';
import 'package:auth_katalog_app/features/dashboard/presentation/widgets/product_detail/product_detail_info_section.dart';
import 'package:flutter/material.dart';

class ProductDetailContent extends StatelessWidget {
  const ProductDetailContent({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 340,
                pinned: true,
                elevation: 4,
                scrolledUnderElevation: 4,
                shadowColor: Colors.black.withValues(alpha: 0.15),
                title: const Text('Detail Produk'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border_rounded),
                    onPressed: () {},
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: ProductDetailImageGallery(product: product),
                ),
              ),
              SliverToBoxAdapter(
                child: ProductDetailInfoSection(product: product),
              ),
            ],
          ),
        ),
        const ProductDetailBottomBar(),
      ],
    );
  }
}
