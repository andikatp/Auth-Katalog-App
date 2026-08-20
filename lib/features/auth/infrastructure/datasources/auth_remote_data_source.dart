import 'package:auth_katalog_app/features/auth/domain/entities/user.dart';
import 'package:auth_katalog_app/features/auth/domain/params/login_params.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(LoginParams params);
  Future<User> getUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required this._dio});
  final Dio _dio;

  @override
  Future<User> login(LoginParams params) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: params.toJson(),
    );
    return User.fromJson(res.data!);
  }

  @override
  Future<User> getUser() async {
    final res = await _dio.get<Map<String, dynamic>>('/auth/me');
    return User.fromJson(res.data!);
  }
}
