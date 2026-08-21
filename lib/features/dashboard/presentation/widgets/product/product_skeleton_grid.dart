import 'package:auth_katalog_app/features/dashboard/domain/entities/product.dart';
import 'package:auth_katalog_app/features/dashboard/presentation/widgets/product/product_card.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductSkeletonGrid extends StatelessWidget {
  const ProductSkeletonGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: List.generate(3, (i) {
            return Padding(
              padding: const .only(bottom: 12),
              child: SizedBox(
                height: 272,
                child: Row(
                  spacing: 12,
                  children: [
                    Expanded(child: ProductCard(product: Product.skeleton())),
                    Expanded(child: ProductCard(product: Product.skeleton())),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
