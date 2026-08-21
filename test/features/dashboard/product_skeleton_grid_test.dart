import 'package:auth_katalog_app/features/dashboard/presentation/widgets/product_skeleton_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'ProductSkeletonGrid renders without layout errors',
    (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ProductSkeletonGrid(),
          ),
        ),
      ),
    );

    expect(find.byType(ProductSkeletonGrid), findsOneWidget);
  });
}
