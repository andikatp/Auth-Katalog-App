import 'package:auth_katalog_app/core/network/core/result.dart';
import 'package:auth_katalog_app/core/network/core/safe_call.dart';
import 'package:auth_katalog_app/core/providers/network_info.dart';
import 'package:auth_katalog_app/core/utils/typedef.dart';
import 'package:auth_katalog_app/features/auth/domain/entities/user.dart';
import 'package:auth_katalog_app/features/auth/domain/params/login_params.dart';
import 'package:auth_katalog_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:auth_katalog_app/features/auth/infrastructure/datasources/auth_local_data_source.dart';
import 'package:auth_katalog_app/features/auth/infrastructure/datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  new({
    required this._remoteDataSource,
    required this._localDataSource,
    required this._networkInfo,
  });
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  @override
  ResultFuture<User> login(LoginParams params) async {
    final result = await safeCall(
      () => _remoteDataSource.login(params),
      networkInfo: _networkInfo,
    );

    if (result.isFailure) {
      return (result.failureOrNull, null);
    }

    final user = result.dataOrNull!;
    final saveResult = await safeCall(
      () => _localDataSource.setToken(
        user.accessToken ?? '',
        user.refreshToken ?? '',
      ),
    );

    if (saveResult.isFailure) {
      return (saveResult.failureOrNull, null);
    }

    return (null, user);
  }

  @override
  ResultFuture<User> checkAuth() async {
    final result = await safeCall(
      _remoteDataSource.getUser,
      networkInfo: _networkInfo,
    );
    return switch (result) {
      Success(:final data) => (null, data),
      ResultFailure(:final failure) => (failure, null),
    };
  }
}
