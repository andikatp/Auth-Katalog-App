import 'package:auth_katalog_app/core/network/dio/dio_client.dart';
import 'package:auth_katalog_app/core/providers/network_info.dart';
import 'package:auth_katalog_app/core/services/token_services.dart';
import 'package:auth_katalog_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:auth_katalog_app/features/auth/infrastructure/datasources/auth_local_data_source.dart';
import 'package:auth_katalog_app/features/auth/infrastructure/datasources/auth_remote_data_source.dart';
import 'package:auth_katalog_app/features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  final tokenService = ref.watch(tokenServiceProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  final remoteDataSource = AuthRemoteDataSourceImpl(dio: dio);
  final localDataSource = AuthLocalDataSourceImpl(tokenService: tokenService);

  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );
}
