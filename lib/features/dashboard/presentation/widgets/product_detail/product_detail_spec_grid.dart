import 'package:auth_katalog_app/core/extensions/build_context_extensions.dart';
import 'package:auth_katalog_app/core/extensions/string_extensions.dart';
import 'package:auth_katalog_app/features/dashboard/domain/entities/product.dart';
import 'package:flutter/material.dart';

class ProductDetailSpecGrid extends StatelessWidget {
  const ProductDetailSpecGrid({required this.product, super.key});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final specs = [
      MapEntry('SKU', product.sku.clean),
      MapEntry('Stok', product.stock.cleanUnit('unit')),
      MapEntry('Berat', product.weight.cleanUnit('kg')),
      MapEntry('Garansi', product.warrantyInformation.clean),
      MapEntry('Pengiriman', product.shippingInformation.clean),
      MapEntry('Retur', product.returnPolicy.clean),
    ];

    return GridView.builder(
      shrinkWrap: true,
      padding: .zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: specs.length,
      itemBuilder: (context, index) {
        final item = specs[index];
        return Container(
          padding: const .symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.5,
            ),
            borderRadius: .circular(8),
          ),
          child: Column(
            crossAxisAlignment: .start,
            mainAxisAlignment: .center,
            children: [
              Text(
                item.key,
                style: context.labelSmall.copyWith(color: context.hintColor),
              ),
              Text(
                item.value,
                maxLines: 1,
                overflow: .ellipsis,
                style: context.bodySmall.copyWith(fontWeight: .w600),
              ),
            ],
          ),
        );
      },
    );
  }
}
