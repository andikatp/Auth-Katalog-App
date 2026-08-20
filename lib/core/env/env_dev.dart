import 'package:envied/envied.dart';

part 'env_dev.g.dart';

@Envied(path: '.env.dev')
abstract class DevEnv {
  @EnviedField(varName: 'HOST', useConstantCase: true)
  static const String host = _DevEnv.host;
}
