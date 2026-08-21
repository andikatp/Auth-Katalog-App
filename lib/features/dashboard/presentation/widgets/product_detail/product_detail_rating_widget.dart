import 'package:auth_katalog_app/core/extensions/build_context_extensions.dart';
import 'package:auth_katalog_app/core/extensions/string_extensions.dart';
import 'package:auth_katalog_app/features/dashboard/domain/entities/product.dart';
import 'package:flutter/material.dart';

class ProductDetailRatingWidget extends StatelessWidget {
  const ProductDetailRatingWidget({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      children: [
        Row(
          spacing: 4,
          children: [
            const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
            Text(
              product.rating?.toStringAsFixed(1) ?? '-',
              style: context.labelMedium,
            ),
          ],
        ),
        Container(
          padding: const .symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.15),
            borderRadius: .circular(4),
          ),
          child: Text(
            product.availabilityStatus.clean,
            style: context.bodySmall.copyWith(
              color: Colors.green.shade700,
              fontWeight: .w600,
            ),
          ),
        ),
      ],
    );
  }
}
