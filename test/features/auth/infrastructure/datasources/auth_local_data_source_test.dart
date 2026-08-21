import 'package:auth_katalog_app/core/services/token_services.dart';
import 'package:auth_katalog_app/features/auth/infrastructure/datasources/auth_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTokenService extends Mock implements TokenService {}

void main() {
  late MockTokenService mockTokenService;
  late AuthLocalDataSourceImpl dataSource;

  setUp(() {
    mockTokenService = MockTokenService();
    dataSource = AuthLocalDataSourceImpl(tokenService: mockTokenService);
  });

  group('AuthLocalDataSource', () {
    test('setToken saves token, refreshToken and expiresInMins', () async {
      when(() => mockTokenService.saveToken('token_123'))
          .thenAnswer((_) async {});
      when(() => mockTokenService.saveRefreshToken('refresh_123'))
          .thenAnswer((_) async {});
      when(() => mockTokenService.saveExpiresInMins(30))
          .thenAnswer((_) async {});

      await dataSource.setToken('token_123', 'refresh_123', expiresInMins: 30);

      verify(() => mockTokenService.saveToken('token_123')).called(1);
      verify(() => mockTokenService.saveRefreshToken('refresh_123')).called(1);
      verify(() => mockTokenService.saveExpiresInMins(30)).called(1);
    });

    test('removeToken clears tokens', () async {
      when(() => mockTokenService.clearTokens()).thenAnswer((_) async {});

      await dataSource.removeToken();

      verify(() => mockTokenService.clearTokens()).called(1);
    });

    test('getToken returns token from tokenService', () async {
      when(() => mockTokenService.token).thenReturn('saved_token');

      final token = await dataSource.getToken();

      expect(token, 'saved_token');
    });
  });
}
