import 'package:auth_katalog_app/core/extensions/build_context_extensions.dart';
import 'package:auth_katalog_app/core/utils/debouncer.dart';
import 'package:auth_katalog_app/features/core/presentations/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class ProductSearchBar extends StatefulWidget {
  const ProductSearchBar({
    required this.onSearchChanged,
    super.key,
    this.initialQuery = '',
  });

  final ValueChanged<String> onSearchChanged;
  final String initialQuery;

  @override
  State<ProductSearchBar> createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {
  late final TextEditingController _controller;
  final Debouncer _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  void _onChanged(String value) {
    _debouncer.run(() => widget.onSearchChanged(value));
    setState(() {});
  }

  void _clear() {
    _controller.clear();
    widget.onSearchChanged('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: _controller,
      hintText: 'Cari produk...',
      prefixIcon: Icon(Icons.search_rounded, color: context.hintColor),
      suffixIcon: _controller.text.isNotEmpty
          ? IconButton(icon: const Icon(Icons.clear_rounded), onPressed: _clear)
          : null,
      onChanged: _onChanged,
    );
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _controller.dispose();
    super.dispose();
  }
}
