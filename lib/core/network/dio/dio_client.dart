import 'package:auth_katalog_app/core/flavors/flavor_config.dart';
import 'package:auth_katalog_app/core/network/errors/api_exception.dart';
import 'package:auth_katalog_app/core/services/token_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:synchronized/synchronized.dart';
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
          enabled: kDebugMode && FlavorConfig.instance.flavor == .dev,
          printRequestHeaders: true,
          printResponseHeaders: true,
        ),
      ),
    );
  dio.interceptors.add(ApiInterceptor(dio: dio, ref: ref));

  return dio;
}

class ApiInterceptor extends InterceptorsWrapper {
  ApiInterceptor({required this._dio, required this._ref});
  final Dio _dio;
  final Ref _ref;
  final Lock _lock = Lock();

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
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
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

    if (err.response?.statusCode == 401) {
      try {
        final response = await _lock.synchronized(() async {
          final currentToken = _ref.read(tokenServiceProvider).token;
          final requestToken = err.requestOptions.headers['Authorization']
              ?.toString()
              .replaceFirst('Bearer ', '');

          if (currentToken != null &&
              currentToken.isNotEmpty &&
              currentToken != requestToken) {
            return _retry(err.requestOptions);
          }

          await _refreshToken();
          return _retry(err.requestOptions);
        });

        return handler.resolve(response);
      } catch (e) {
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error:
                e is ApiException ? e : ServerException(_extractMessage(err)),
          ),
        );
      }
    }

    return handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: ServerException(_extractMessage(err)),
      ),
    );
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) {
    final token = _ref.read(tokenServiceProvider).token;
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<void> _refreshToken() async {
    final tokenService = _ref.read(tokenServiceProvider);
    final refreshToken = tokenService.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      throw const CacheException('Refresh token not found');
    }
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: {
        'refreshToken': refreshToken,
        'expiresInMins': tokenService.expiresInMins,
      },
    );
    if (response.statusCode == 200) {
      final data = response.data!;
      final accessToken = data['accessToken'] as String;
      final refreshToken = data['refreshToken'] as String;
      await tokenService.saveToken(accessToken);
      await tokenService.saveRefreshToken(refreshToken);
    }
  }

  String _extractMessage(DioException err) {
    final data = err.response?.data;
    if (data is Map<String, dynamic>) {
      return (data['message'] as String?) ?? 'Something went wrong';
    }
    return 'Something went wrong';
  }
}
