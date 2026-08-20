import 'package:auth_katalog_app/features/auth/domain/entities/user_address.dart';
import 'package:auth_katalog_app/features/auth/domain/entities/user_company.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
sealed class User with _$User {
  const factory User({
    required int id,
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required String gender,
    required String image,
    String? phone,
    String? birthDate,
    String? role,
    UserCompany? company,
    UserAddress? address,
    String? accessToken,
    String? refreshToken,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
