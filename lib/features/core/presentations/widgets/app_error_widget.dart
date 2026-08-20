import 'package:auth_katalog_app/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    required this.message,
    super.key,
    this.title = 'Something went wrong',
    this.onRetry,
    this.buttonText = 'Try Again',
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const .all(24),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: context.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: .center,
              style: context.titleMedium.copyWith(fontWeight: .bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: .center,
              style: context.bodyMedium.copyWith(
                color: context.hintColor,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(buttonText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
