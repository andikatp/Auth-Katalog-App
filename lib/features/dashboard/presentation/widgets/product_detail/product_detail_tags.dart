import 'package:flutter/material.dart';

class ProductDetailTags extends StatelessWidget {
  const ProductDetailTags({required this.tags, super.key});
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags
          .map(
            (tag) => Chip(
              avatar: const Icon(Icons.tag, size: 14),
              label: Text(tag),
              visualDensity: .compact,
            ),
          )
          .toList(),
    );
  }
}
