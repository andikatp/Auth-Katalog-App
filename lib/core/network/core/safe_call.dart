import 'dart:developer';

import 'package:auth_katalog_app/core/network/core/result.dart';
import 'package:auth_katalog_app/core/network/errors/api_exception.dart';
import 'package:auth_katalog_app/core/network/errors/failure.dart';
import 'package:auth_katalog_app/core/providers/network_info.dart';
import 'package:dio/dio.dart';

Future<Result<T>> safeCall<T>(
  Future<T> Function() apiCall, {
  NetworkInfo? networkInfo,
}) async {
  if (networkInfo != null && !await networkInfo.isConnected) {
    return const .failure(InternetFailure());
  }

  try {
    final result = await apiCall();
    return .success(result);
  } on DioException catch (e, s) {
    log('DioException: $e');
    log('Stack Trace: $s');
    if (e.error is ServerException) {
      final error = e.error! as ServerException;
      return .failure(ServerFailure(error.message));
    }
    return const .failure(ServerFailure('Upps.. Terjadi Kesalahan'));
  } on FormatException catch (e, s) {
    log('FormatException: $e');
    log('Stack Trace: $s');
    return .failure(CacheFailure('Invalid data format: ${e.message}'));
  } on CacheException catch (e, s) {
    log('FormatException: $e');
    log('Stack Trace: $s');
    return .failure(CacheFailure(e.message));
  } catch (e, s) {
    log('FormatException: $e');
    log('Stack Trace: $s');
    if (e is Error) {
      return .failure(
        ServerFailure('An unexpected error occurred: $e'),
      );
    }
    return .failure(
      ServerFailure((e as Exception).toString()),
    );
  }
}
