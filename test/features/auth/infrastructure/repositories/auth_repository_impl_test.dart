import 'package:auth_katalog_app/core/providers/network_info.dart';
import 'package:auth_katalog_app/features/auth/domain/entities/user.dart';
import 'package:auth_katalog_app/features/auth/domain/params/login_params.dart';
import 'package:auth_katalog_app/features/auth/infrastructure/datasources/auth_local_data_source.dart';
import 'package:auth_katalog_app/features/auth/infrastructure/datasources/auth_remote_data_source.dart';
import 'package:auth_katalog_app/features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );

    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
  });

  final dummyUser = User.skeleton().copyWith(
    id: 1,
    username: 'emilys',
    accessToken: 'access_123',
    refreshToken: 'refresh_123',
  );

  group('AuthRepositoryImpl', () {
    test('login succeeds and saves tokens locally', () async {
      const params = LoginParams(username: 'emilys', password: 'password');

      when(() => mockRemoteDataSource.login(params))
          .thenAnswer((_) async => dummyUser);
      when(
        () => mockLocalDataSource.setToken(
          'access_123',
          'refresh_123',
          expiresInMins: params.expiresInMins,
        ),
      ).thenAnswer((_) async {});

      final (failure, user) = await repository.login(params);

      expect(failure, isNull);
      expect(user, equals(dummyUser));
      verify(() => mockRemoteDataSource.login(params)).called(1);
      verify(
        () => mockLocalDataSource.setToken(
          'access_123',
          'refresh_123',
          expiresInMins: params.expiresInMins,
        ),
      ).called(1);
    });

    test('checkAuth returns user on remote success', () async {
      when(() => mockRemoteDataSource.getUser())
          .thenAnswer((_) async => dummyUser);

      final (failure, user) = await repository.checkAuth();

      expect(failure, isNull);
      expect(user, equals(dummyUser));
      verify(() => mockRemoteDataSource.getUser()).called(1);
    });

    test('logout clears local token', () async {
      when(() => mockLocalDataSource.removeToken()).thenAnswer((_) async {});

      final (failure, _) = await repository.logout();

      expect(failure, isNull);
      verify(() => mockLocalDataSource.removeToken()).called(1);
    });
  });
}
