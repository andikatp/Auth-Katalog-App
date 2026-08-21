import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
sealed class Product with _$Product {
  const factory Product({
    required int id,
    required String title,
    required double price,
    required String thumbnail,
    String? description,
    String? category,
    double? discountPercentage,
    double? rating,
    int? stock,
    List<String>? tags,
    String? brand,
    String? sku,
    num? weight,
    String? warrantyInformation,
    String? shippingInformation,
    String? availabilityStatus,
    String? returnPolicy,
    int? minimumOrderQuantity,
    List<String>? images,
  }) = _Product;

  const Product._();

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  factory Product.skeleton() => const Product(
        id: 0,
        title: 'Loading Product Name Placeholder',
        price: 99.99,
        thumbnail: '',
        brand: 'Brand',
        rating: 4.5,
      );
}
