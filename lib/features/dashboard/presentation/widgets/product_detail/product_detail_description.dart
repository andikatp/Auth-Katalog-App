import 'package:auth_katalog_app/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

class ProductDetailDescription extends StatelessWidget {
  const ProductDetailDescription({this.description, super.key});

  final String? description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 8,
      children: [
        Text(
          'Deskripsi Produk',
          style: context.titleMedium.copyWith(fontWeight: .bold),
        ),
        Text(
          description ?? 'Tidak ada deskripsi tersedia.',
          style: context.bodyMedium.copyWith(
            height: 1.5,
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
