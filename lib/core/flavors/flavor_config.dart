import 'package:auth_katalog_app/core/env/env_dev.dart';

enum FlavorType {
  dev,
  stage,
  prod,
}

class FlavorValues {
  const FlavorValues({
    this.appTitle = 'Auth Katalog [DEV]',
    this.host = DevEnv.host,
  });

  final String appTitle;
  final String host;
}

class FlavorConfig {
  FlavorConfig._privateConstructor({
    this.flavor = FlavorType.dev,
    this.values = const FlavorValues(),
  });

  static bool _initialized = false;

  static FlavorConfig? _instance;

  static void reset() {
    _instance = null;
    _initialized = false;
  }

  static void initialize({
    FlavorType flavor = FlavorType.dev,
    FlavorValues values = const FlavorValues(),
  }) {
    if (_initialized) {
      throw StateError('FlavorConfig has already been initialized.');
    }
    _instance = ._privateConstructor(
      flavor: flavor,
      values: values,
    );
    _initialized = true;
  }

  static FlavorConfig get instance {
    if (_instance == null) {
      throw StateError(
        'FlavorConfig has not been initialized. Call initialize() first.',
      );
    }
    return _instance!;
  }

  final FlavorType flavor;
  final FlavorValues values;
}
