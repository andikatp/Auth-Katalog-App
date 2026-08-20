import 'package:auth_katalog_app/core/flavors/flavor_config.dart';
import 'package:auth_katalog_app/core/services/theme_service.dart';
import 'package:auth_katalog_app/core/services/token_services.dart';
import 'package:auth_katalog_app/features/core/utils/loading.dart';
import 'package:auth_katalog_app/features/core/utils/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig.initialize();
  configLoading();

  final container = ProviderContainer();

  await Future.wait([
    container.read(tokenServiceProvider).init(),
    container.read(themeServiceProvider).init(),
  ]);

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}
