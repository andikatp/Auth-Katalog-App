import 'package:auth_katalog_app/core/flavors/flavor_config.dart';
import 'package:auth_katalog_app/features/core/utils/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  FlavorConfig.initialize();
  runApp(const ProviderScope(child: MyApp()));
}
