import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_exception.freezed.dart';
part 'api_exception.g.dart';

@freezed
sealed class ApiException with _$ApiException implements Exception {
  const factory ApiException.cache(String message) = CacheException;
  const factory ApiException.server(String message) = ServerException;
  const factory ApiException.custom(String message) = CustomException;

  factory ApiException.fromJson(Map<String, dynamic> json) =>
      _$ApiExceptionFromJson(json);
}
