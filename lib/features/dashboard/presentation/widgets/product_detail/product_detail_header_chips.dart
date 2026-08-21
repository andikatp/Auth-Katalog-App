import 'package:auth_katalog_app/core/extensions/build_context_extensions.dart';
import 'package:auth_katalog_app/core/extensions/string_extensions.dart';
import 'package:auth_katalog_app/features/dashboard/domain/entities/product.dart';
import 'package:flutter/material.dart';

class ProductDetailHeaderChips extends StatelessWidget {
  const ProductDetailHeaderChips({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Chip(
          backgroundColor: context.colorScheme.primaryContainer,
          side: BorderSide.none,
          label: Text(
            product.brand.clean,
            style: TextStyle(
              color: context.colorScheme.onPrimaryContainer,
              fontWeight: .bold,
            ),
          ),
          visualDensity: .compact,
          materialTapTargetSize: .shrinkWrap,
        ),
        Chip(
          label: Text(product.category.clean),
          visualDensity: .compact,
          materialTapTargetSize: .shrinkWrap,
        ),
      ],
    );
  }
}
