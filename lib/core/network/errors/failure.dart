import 'package:auth_katalog_app/core/network/errors/api_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
sealed class Failure with _$Failure implements Exception {
  const factory Failure.cache(String message) = CacheFailure;
  const factory Failure.server(String message) = ServerFailure;
  const factory Failure.internet() = InternetFailure;

  factory Failure.fromCacheException(CacheException exception) =>
      CacheFailure(exception.message);

  factory Failure.fromServerException(ServerException exception) =>
      ServerFailure(exception.message);
}

extension FailureX on Failure {
  String get errorMessage {
    return when(
      cache: (message) => message,
      server: (message) => message,
      internet: () => 'No internet connection',
    );
  }
}
