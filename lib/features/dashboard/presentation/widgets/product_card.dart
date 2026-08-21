import 'package:auth_katalog_app/core/extensions/build_context_extensions.dart';
import 'package:auth_katalog_app/core/extensions/string_extensions.dart';
import 'package:auth_katalog_app/core/providers/currency_converter.dart';
import 'package:auth_katalog_app/features/core/presentations/widgets/app_network_image.dart';
import 'package:auth_katalog_app/features/dashboard/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({required this.product, super.key});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idrPriceAsync = ref.watch(formattedIdrPriceProvider(product.price));
    final textThemeCurr = context.titleMedium.copyWith(
      color: context.primaryColor,
      fontWeight: .bold,
    );
    return Card(
      elevation: 2,
      clipBehavior: .antiAlias,
      shape: RoundedRectangleBorder(borderRadius: .circular(12)),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: AppNetworkImage(imageUrl: product.thumbnail),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const .symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: .circular(6),
                    ),
                    child: Text(
                      product.brand.clean,
                      style: context.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: .w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const .all(12),
            child: Column(
              spacing: 8,
              crossAxisAlignment: .start,
              children: [
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: .ellipsis,
                  style: context.titleSmall.copyWith(fontWeight: .bold),
                ),
                idrPriceAsync.when(
                  data: (price) => Text(price, style: textThemeCurr),
                  loading: () => Text('Loading...', style: textThemeCurr),
                  error: (_, _) => Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: textThemeCurr,
                  ),
                ),
                if (product.rating != null) ...[
                  Row(
                    spacing: 4,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: Colors.amber,
                      ),
                      Text(
                        product.rating!.toStringAsFixed(1),
                        style: context.bodySmall.copyWith(
                          color: context.hintColor,
                          fontWeight: .w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
