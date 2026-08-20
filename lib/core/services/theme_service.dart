import 'package:auth_katalog_app/core/constants/app_keys.dart';
import 'package:auth_katalog_app/core/providers/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_service.g.dart';

@Riverpod(keepAlive: true)
ThemeService themeService(Ref ref) {
  final storage = ref.watch(secureStorageProvider);
  return ThemeService(storage);
}

class ThemeService {
  ThemeService(this._storage);

  final FlutterSecureStorage _storage;
  ThemeMode? _themeMode;

  Future<void> init() async {
    final results = await _storage.read(key: AppKeys.themeMode);
    _themeMode = ThemeMode.values.firstWhere(
      (e) => e.name == results,
      orElse: () => .light,
    );
  }

  ThemeMode? get themeMode => _themeMode;

  Future<void> changeTheme(ThemeMode theme) async {
    _themeMode = theme;
    await _storage.write(key: AppKeys.themeMode, value: theme.name);
  }
}
