import 'package:auth_katalog_app/core/constants/app_colors.dart';
import 'package:auth_katalog_app/core/services/theme_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_theme.g.dart';

@riverpod
class AppTheme extends _$AppTheme {
  @override
  ThemeMode build() {
    return ref.read(themeServiceProvider).themeMode ?? .system;
  }

  Future<void> changeTheme(ThemeMode mode) async {
    state = mode;
    await ref.read(themeServiceProvider).changeTheme(mode);
  }

  static ThemeData buildLightTheme() => ThemeData(
        brightness: .light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.kPrimaryColor),
        cupertinoOverrideTheme: const CupertinoThemeData(brightness: .light),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: .circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: .circular(8),
            borderSide: BorderSide(color: AppColors.kBorderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: .circular(8),
            borderSide: BorderSide(color: AppColors.kBorderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: .circular(8),
            borderSide: const BorderSide(
              color: AppColors.kPrimaryColor,
              width: 1.5,
            ),
          ),
          fillColor: const Color(0xFFF8FAFC),
          filled: true,
          contentPadding: const .symmetric(
            horizontal: 14,
            vertical: 12,
          ),
        ),
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.white,
          scrolledUnderElevation: 0,
          foregroundColor: Color(0xFF1E293B),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      );

  static ThemeData buildDarkTheme() => ThemeData(
        brightness: .dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.kPrimaryColor,
          brightness: .dark,
        ),
        cupertinoOverrideTheme: const CupertinoThemeData(
          brightness: .dark,
          barBackgroundColor: Color(0xFF1E293B),
          scaffoldBackgroundColor: Color(0xFF0F172A),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: .circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: .circular(8),
            borderSide: const BorderSide(color: Color(0xFF334155)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: .circular(8),
            borderSide: const BorderSide(color: Color(0xFF334155)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: .circular(8),
            borderSide: const BorderSide(
              color: AppColors.kPrimaryColor,
              width: 1.5,
            ),
          ),
          fillColor: const Color(0xFF1E293B),
          filled: true,
          contentPadding: const .symmetric(
            horizontal: 14,
            vertical: 12,
          ),
        ),
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Color(0xFF0F172A),
          scrolledUnderElevation: 0,
          foregroundColor: Color(0xFFF8FAFC),
          backgroundColor: Color(0xFF0F172A),
          elevation: 0,
        ),
      );
}
