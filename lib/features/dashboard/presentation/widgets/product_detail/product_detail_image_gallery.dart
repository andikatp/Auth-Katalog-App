import 'package:auth_katalog_app/core/extensions/build_context_extensions.dart';
import 'package:auth_katalog_app/features/core/presentations/widgets/app_network_image.dart';
import 'package:auth_katalog_app/features/dashboard/domain/entities/product.dart';
import 'package:flutter/material.dart';

class ProductDetailImageGallery extends StatelessWidget {
  const ProductDetailImageGallery({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final imageUrl = (product.images != null && product.images!.isNotEmpty)
        ? product.images!.first
        : product.thumbnail;
    final discount = product.discountPercentage;

    return Stack(
      children: [
        Positioned.fill(child: AppNetworkImage(imageUrl: imageUrl)),
        if (discount != null && discount > 0)
          Positioned(
            top: kToolbarHeight + MediaQuery.paddingOf(context).top + 8,
            left: 16,
            child: Container(
              padding: const .symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.shade600,
                borderRadius: .circular(8),
              ),
              child: Text(
                '-${discount.toInt()}%',
                style: context.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: .bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
