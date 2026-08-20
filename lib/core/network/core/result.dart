import 'package:auth_katalog_app/core/network/errors/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
sealed class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure failure) = ResultFailure<T>;
}

extension ResultExtension<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is ResultFailure<T>;

  T? get dataOrNull => switch (this) {
    Success(:final data) => data,
    _ => null,
  };

  Failure? get failureOrNull => switch (this) {
    ResultFailure(:final failure) => failure,
    _ => null,
  };
}
