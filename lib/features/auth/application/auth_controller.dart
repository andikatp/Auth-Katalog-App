import 'package:auth_katalog_app/core/network/errors/failure.dart';
import 'package:auth_katalog_app/features/auth/application/auth_state.dart';
import 'package:auth_katalog_app/features/auth/auth_provider.dart';
import 'package:auth_katalog_app/features/auth/domain/params/login_params.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  AuthState build() => const AuthState.initial();

  Future<void> checkAuth() async {
    final (failure, user) = await ref.read(authRepositoryProvider).checkAuth();
    if (failure != null) {
      state = AuthState.failure(failure.errorMessage);
      return;
    }

    state = AuthState.success(user!);
  }

  Future<void> login(LoginParams params) async {
    state = const AuthState.loading();
    final (failure, user) = await ref
        .read(authRepositoryProvider)
        .login(params);

    if (failure != null) {
      state = AuthState.failure(failure.errorMessage);
      return;
    }

    state = AuthState.success(user!);
  }
}
