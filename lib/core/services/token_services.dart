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

  static const int defaultExpiresInMins = 30;

  final FlutterSecureStorage _storage;
  String? _token;
  String? _refreshToken;
  int? _expiresInMins;

  Future<void> init() async {
    final results = await Future.wait([
      _storage.read(key: AppKeys.tokenKey),
      _storage.read(key: AppKeys.refreshKey),
      _storage.read(key: AppKeys.expiresInMinsKey),
    ]);
    _token = results[0];
    _refreshToken = results[1];
    _expiresInMins = results[2] != null ? int.tryParse(results[2]!) : null;
  }

  String? get token => _token;
  String? get refreshToken => _refreshToken;
  int get expiresInMins => _expiresInMins ?? defaultExpiresInMins;

  Future<void> saveToken(String token) async {
    _token = token;
    await _storage.write(key: AppKeys.tokenKey, value: token);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    _refreshToken = refreshToken;
    await _storage.write(key: AppKeys.refreshKey, value: refreshToken);
  }

  Future<void> saveExpiresInMins(int expiresInMins) async {
    _expiresInMins = expiresInMins;
    await _storage.write(
      key: AppKeys.expiresInMinsKey,
      value: expiresInMins.toString(),
    );
  }

  Future<void> clearTokens() async {
    _token = null;
    _refreshToken = null;
    _expiresInMins = null;
    await Future.wait([
      _storage.delete(key: AppKeys.tokenKey),
      _storage.delete(key: AppKeys.refreshKey),
      _storage.delete(key: AppKeys.expiresInMinsKey),
    ]);
  }
}
