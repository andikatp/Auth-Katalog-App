import 'package:auth_katalog_app/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

class ProductEmptyWidget extends StatelessWidget {
  const ProductEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        spacing: 12,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: context.hintColor,
          ),
          Text(
            'Produk tidak ditemukan',
            style: context.titleMedium.copyWith(color: context.hintColor),
          ),
        ],
      ),
    );
  }
}
