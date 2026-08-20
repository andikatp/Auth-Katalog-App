import 'package:auth_katalog_app/core/services/token_services.dart';

abstract class AuthLocalDataSource {
  const AuthLocalDataSource();

  Future<void> setToken(String token, String refreshToken);
  Future<void> removeToken();
  Future<String?> getToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({required this._tokenService});
  final TokenService _tokenService;

  @override
  Future<void> setToken(String token, String refreshToken) async {
    await Future.wait([
      _tokenService.saveToken(token),
      _tokenService.saveRefreshToken(refreshToken),
    ]);
  }

  @override
  Future<void> removeToken() => _tokenService.clearTokens();

  @override
  Future<String?> getToken() async => _tokenService.token;
}
