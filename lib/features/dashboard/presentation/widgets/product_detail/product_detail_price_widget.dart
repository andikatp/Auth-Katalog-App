import 'package:auth_katalog_app/core/extensions/build_context_extensions.dart';
import 'package:auth_katalog_app/core/providers/currency_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailPriceWidget extends ConsumerWidget {
  const ProductDetailPriceWidget({required this.price, super.key});
  final double price;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idrPriceAsync = ref.watch(formattedIdrPriceProvider(price));
    final textTheme = context.headlineMedium.copyWith(
      color: context.primaryColor,
      fontWeight: .w800,
    );

    return Column(
      crossAxisAlignment: .start,
      children: [
        idrPriceAsync.when(
          data: (formattedPrice) => Text(formattedPrice, style: textTheme),
          loading: () => Text('Memuat harga...', style: textTheme),
          error: (_, _) => Text(
            '\$${price.toStringAsFixed(2)}',
            style: textTheme,
          ),
        ),
        Text(
          'USD \$${price.toStringAsFixed(2)}',
          style: context.bodySmall.copyWith(
            color: context.hintColor,
          ),
        ),
      ],
    );
  }
}
