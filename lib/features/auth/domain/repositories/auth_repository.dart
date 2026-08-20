import 'package:auth_katalog_app/core/utils/typedef.dart';
import 'package:auth_katalog_app/features/auth/domain/entities/user.dart';
import 'package:auth_katalog_app/features/auth/domain/params/login_params.dart';

abstract class AuthRepository {
  const AuthRepository();

  ResultFuture<User> login(LoginParams params);
  ResultFuture<User> checkAuth();
  ResultFuture<void> logout();
}
