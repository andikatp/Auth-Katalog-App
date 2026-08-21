import 'package:auth_katalog_app/features/auth/domain/params/login_params.dart';
import 'package:auth_katalog_app/features/auth/infrastructure/datasources/auth_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = AuthRemoteDataSourceImpl(dio: mockDio);
  });

  final dummyUserJson = jsonFixture('user.json');

  group('AuthRemoteDataSource', () {
    test('login returns User when dio post succeeds', () async {
      const params = LoginParams(username: 'emilys', password: 'password');

      final response = Response<Map<String, dynamic>>(
        data: dummyUserJson,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/auth/login'),
      );

      when(
        () => mockDio.post<Map<String, dynamic>>(
          '/auth/login',
          data: params.toJson(),
        ),
      ).thenAnswer((_) async => response);

      final user = await dataSource.login(params);

      expect(user.id, equals(1));
      expect(user.username, equals('emilys'));
      expect(user.accessToken, equals('dummy_access_token'));
      verify(
        () => mockDio.post<Map<String, dynamic>>(
          '/auth/login',
          data: params.toJson(),
        ),
      ).called(1);
    });

    test('getUser returns User when dio get succeeds', () async {
      final response = Response<Map<String, dynamic>>(
        data: dummyUserJson,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/auth/me'),
      );

      when(
        () => mockDio.get<Map<String, dynamic>>('/auth/me'),
      ).thenAnswer((_) async => response);

      final user = await dataSource.getUser();

      expect(user.id, equals(1));
      expect(user.username, equals('emilys'));
      verify(() => mockDio.get<Map<String, dynamic>>('/auth/me')).called(1);
    });
  });
}
