import 'package:auth_katalog_app/core/extensions/build_context_extensions.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    required this.imageUrl,
    super.key,
    this.width,
    this.height,
    this.fit = .cover,
    this.shape = .rectangle,
    this.borderRadius,
    this.errorWidget,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BoxShape shape;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return errorWidget ?? _buildDefaultError(context);
    }

    return ExtendedImage.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      shape: shape,
      borderRadius: borderRadius,
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case .loading:
            return ColoredBox(
              color: context.colorScheme.surfaceContainerHighest,
              child: const Center(child: CircularProgressIndicator.adaptive()),
            );
          case .failed:
            return errorWidget ?? _buildDefaultError(context);
          case .completed:
            return null;
        }
      },
    );
  }

  Widget _buildDefaultError(BuildContext context) {
    return ColoredBox(
      color: context.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.broken_image_rounded,
          color: context.hintColor,
          size: 32,
        ),
      ),
    );
  }
}
