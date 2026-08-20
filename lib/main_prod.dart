import 'package:auth_katalog_app/core/env/env_prod.dart';
import 'package:auth_katalog_app/core/flavors/flavor_config.dart';
import 'package:auth_katalog_app/features/core/utils/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  FlavorConfig.initialize(
    flavor: FlavorType.prod,
    values: FlavorValues(
      appTitle: 'Auth Katalog',
      host: ProdEnv.host,
    ),
  );
  runApp(const ProviderScope(child: MyApp()));
}
