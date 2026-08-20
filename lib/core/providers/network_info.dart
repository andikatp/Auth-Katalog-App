import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_info.g.dart';

abstract class NetworkInfo {
  const NetworkInfo();

  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  const NetworkInfoImpl(this._networkInfo);
  final InternetConnection _networkInfo;

  @override
  Future<bool> get isConnected => _networkInfo.hasInternetAccess;
}

@Riverpod(keepAlive: true)
InternetConnection internetConnection(Ref _) {
  return InternetConnection();
}

@Riverpod(keepAlive: true)
NetworkInfo networkInfo(Ref ref) {
  final internet = ref.watch(internetConnectionProvider);
  return NetworkInfoImpl(internet);
}
