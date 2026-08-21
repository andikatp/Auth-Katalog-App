import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_products_params.freezed.dart';
part 'get_products_params.g.dart';

@freezed
sealed class GetProductsParams with _$GetProductsParams {
  const factory GetProductsParams({
    required int skip,
    @Default(10) int limit,
    String? query,
  }) = _GetProductsParams;

  factory GetProductsParams.fromJson(Map<String, dynamic> json) =>
      _$GetProductsParamsFromJson(json);
}
