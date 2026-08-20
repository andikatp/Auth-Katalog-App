import 'package:auth_katalog_app/core/flavors/flavor_config.dart';
import 'package:auth_katalog_app/core/network/errors/api_exception.dart';
import 'package:auth_katalog_app/core/services/token_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'dio_client.g.dart';

@riverpod
Dio dio(Ref ref) {
  final talker = TalkerFlutter.init();

  final dio = Dio()
    ..options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    )
    ..interceptors.add(
      TalkerDioLogger(
        talker: talker,
        settings: TalkerDioLoggerSettings(
          enabled: kDebugMode && FlavorConfig.instance.flavor == FlavorType.dev,
          printRequestHeaders: true,
          printResponseHeaders: true,
        ),
      ),
    );
  dio.interceptors.add(ApiInterceptor(ref: ref));

  return dio;
}

class ApiInterceptor extends InterceptorsWrapper {
  ApiInterceptor({required this._ref});

  final Ref _ref;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.baseUrl = FlavorConfig.instance.values.host;

    final token = _ref.read(tokenServiceProvider).token;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final token = _ref.read(tokenServiceProvider).token;
    final path = err.requestOptions.path;
    if (path == '/auth/me' && (token == null || token.isEmpty)) {
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: ServerException(_extractMessage(err)),
        ),
      );
    }
    return handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: ServerException(_extractMessage(err)),
      ),
    );
  }

  String _extractMessage(DioException err) {
    final data = err.response?.data;
    if (data is Map<String, dynamic>) {
      return (data['message'] as String?) ?? 'Something went wrong';
    }
    return 'Something went wrong';
  }
}
