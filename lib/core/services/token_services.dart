import 'package:auth_katalog_app/core/constants/app_keys.dart';
import 'package:auth_katalog_app/core/providers/secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_services.g.dart';

@Riverpod(keepAlive: true)
TokenService tokenService(Ref ref) {
  final storage = ref.watch(secureStorageProvider);
  return TokenService(storage);
}

class TokenService {
  TokenService(this._storage);

  final FlutterSecureStorage _storage;
  String? _token;
  String? _refreshToken;

  Future<void> init() async {
    final results = await Future.wait([
      _storage.read(key: AppKeys.tokenKey),
      _storage.read(key: AppKeys.refreshKey),
    ]);
    _token = results[0];
    _refreshToken = results[1];
  }

  String? get token => _token;
  String? get refreshToken => _refreshToken;

  Future<void> saveToken(String token) async {
    _token = token;
    await _storage.write(key: AppKeys.tokenKey, value: token);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    _refreshToken = refreshToken;
    await _storage.write(key: AppKeys.refreshKey, value: refreshToken);
  }

  Future<void> clearTokens() async {
    _token = null;
    _refreshToken = null;
    await Future.wait([
      _storage.delete(key: AppKeys.tokenKey),
      _storage.delete(key: AppKeys.refreshKey),
    ]);
  }
}
