import 'package:auth_katalog_app/core/constants/app_keys.dart';
import 'package:auth_katalog_app/core/flavors/flavor_config.dart';
import 'package:auth_katalog_app/core/network/dio/dio_client.dart';
import 'package:auth_katalog_app/core/services/token_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockDio extends Mock implements Dio {}

class RequestInterceptorHandlerMock extends Mock
    implements ErrorInterceptorHandler {}

class ResponseFake extends Fake implements Response<dynamic> {}

class DioExceptionFake extends Fake implements DioException {}

void main() {
  setUpAll(() {
    FlavorConfig.reset();
    FlavorConfig.initialize();
    registerFallbackValue(ResponseFake());
    registerFallbackValue(DioExceptionFake());
  });

  late MockFlutterSecureStorage mockStorage;
  late TokenService tokenService;
  late ProviderContainer container;
  late Ref ref;
  late MockDio mockDio;
  late ApiInterceptor interceptor;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    tokenService = TokenService(mockStorage);
    mockDio = MockDio();

    container = ProviderContainer(
      overrides: [
        tokenServiceProvider.overrideWithValue(tokenService),
      ],
    );

    container.read(
      Provider((r) {
        ref = r;
        return null;
      }),
    );

    when(
      () => mockStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => mockStorage.delete(key: any(named: 'key')),
    ).thenAnswer((_) async {});
    when(
      () => mockStorage.read(key: any(named: 'key')),
    ).thenAnswer((_) async => null);

    interceptor = ApiInterceptor(dio: mockDio, ref: ref);
  });

  tearDown(() {
    container.dispose();
  });

  group('ApiInterceptor - Single Flight & Transparent Refresh', () {
    test(
      'calls /auth/refresh EXACTLY ONCE for multiple concurrent 401 requests (Single-Flight)',
      () async {
        when(() => mockStorage.read(key: AppKeys.tokenKey))
            .thenAnswer((_) async => 'old_access_token');
        when(() => mockStorage.read(key: AppKeys.refreshKey))
            .thenAnswer((_) async => 'valid_refresh_token');
        when(() => mockStorage.read(key: AppKeys.expiresInMinsKey))
            .thenAnswer((_) async => '30');

        await tokenService.init();

        var refreshCallCount = 0;
        when(
          () => mockDio.post<Map<String, dynamic>>(
            '/auth/refresh',
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async {
          refreshCallCount++;
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return Response<Map<String, dynamic>>(
            data: {
              'accessToken': 'new_access_token',
              'refreshToken': 'new_refresh_token',
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/auth/refresh'),
          );
        });

        when(
          () => mockDio.request<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((invocation) async {
          final path = invocation.positionalArguments[0] as String;
          return Response<dynamic>(
            data: {'status': 'success', 'path': path},
            statusCode: 200,
            requestOptions: RequestOptions(path: path),
          );
        });

        final err1 = DioException(
          requestOptions: RequestOptions(
            path: '/test1',
            headers: {'Authorization': 'Bearer old_access_token'},
          ),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/test1'),
          ),
        );

        final err2 = DioException(
          requestOptions: RequestOptions(
            path: '/test2',
            headers: {'Authorization': 'Bearer old_access_token'},
          ),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/test2'),
          ),
        );

        final err3 = DioException(
          requestOptions: RequestOptions(
            path: '/test3',
            headers: {'Authorization': 'Bearer old_access_token'},
          ),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/test3'),
          ),
        );

        final handler1 = RequestInterceptorHandlerMock();
        final handler2 = RequestInterceptorHandlerMock();
        final handler3 = RequestInterceptorHandlerMock();

        await Future.wait([
          interceptor.onError(err1, handler1),
          interceptor.onError(err2, handler2),
          interceptor.onError(err3, handler3),
        ]);

        expect(refreshCallCount, equals(1));
        expect(tokenService.token, equals('new_access_token'));
        expect(tokenService.refreshToken, equals('new_refresh_token'));

        verify(() => handler1.resolve(any())).called(1);
        verify(() => handler2.resolve(any())).called(1);
        verify(() => handler3.resolve(any())).called(1);
      },
    );

    test('clears tokens (clean logout) when token refresh fails', () async {
      when(() => mockStorage.read(key: AppKeys.tokenKey))
          .thenAnswer((_) async => 'old_access_token');
      when(() => mockStorage.read(key: AppKeys.refreshKey))
          .thenAnswer((_) async => 'expired_refresh_token');
      when(() => mockStorage.read(key: AppKeys.expiresInMinsKey))
          .thenAnswer((_) async => '30');

      await tokenService.init();

      when(
        () => mockDio.post<Map<String, dynamic>>(
          '/auth/refresh',
          data: any(named: 'data'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/refresh'),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/auth/refresh'),
          ),
        ),
      );

      final err = DioException(
        requestOptions: RequestOptions(
          path: '/test',
          headers: {'Authorization': 'Bearer old_access_token'},
        ),
        response: Response(
          statusCode: 401,
          requestOptions: RequestOptions(path: '/test'),
        ),
      );

      final handler = RequestInterceptorHandlerMock();

      await interceptor.onError(err, handler);

      expect(tokenService.token, isNull);
      expect(tokenService.refreshToken, isNull);

      verify(() => handler.reject(any())).called(1);
    });
  });
}
