import 'package:auth_katalog_app/features/dashboard/dashboard_provider.dart';
import 'package:auth_katalog_app/features/dashboard/domain/entities/product.dart';
import 'package:auth_katalog_app/features/dashboard/domain/params/get_products_params.dart';
import 'package:auth_katalog_app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:auth_katalog_app/features/dashboard/presentation/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDashboardRepository extends Mock implements DashboardRepository {}

void main() {
  late MockDashboardRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(const GetProductsParams(skip: 0, query: ''));
  });

  setUp(() {
    mockRepository = MockDashboardRepository();
  });

  testWidgets('ProductDetailScreen renders detail correctly', (tester) async {
    const product = Product(
      id: 1,
      title: 'Essence Mascara Lash Princess',
      price: 9.99,
      thumbnail: 'https://cdn.dummyjson.com/products/images/beauty/1.png',
      brand: 'Essence',
      category: 'beauty',
    );

    when(() => mockRepository.getProductDetail(1)).thenAnswer(
      (_) async => (null, product),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: const MaterialApp(
          home: ProductDetailScreen(id: 1),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Essence Mascara Lash Princess'), findsOneWidget);
    expect(find.text('Detail Produk'), findsOneWidget);
  });
}
