import 'package:auth_katalog_app/core/theme/app_theme.dart';
import 'package:auth_katalog_app/routers/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(appThemeProvider);

    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: AppTheme.buildLightTheme(),
      darkTheme: AppTheme.buildDarkTheme(),
      themeMode: themeMode,
      routerConfig: router,
      builder: EasyLoading.init(),
    );
  }
}
