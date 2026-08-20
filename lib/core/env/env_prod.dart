import 'package:envied/envied.dart';

part 'env_prod.g.dart';

@Envied(path: '.env')
abstract class ProdEnv {
  @EnviedField(varName: 'HOST', useConstantCase: true, obfuscate: true)
  static final String host = _ProdEnv.host;
}
