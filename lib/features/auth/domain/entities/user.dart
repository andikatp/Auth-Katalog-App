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

  const User._();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.skeleton() => User(
        id: 0,
        username: 'username_placeholder',
        email: 'user.email@example.com',
        firstName: 'Firstname',
        lastName: 'Lastname',
        gender: 'Gender',
        image: '',
        phone: '+1 234 567 8900',
        birthDate: '1990-01-01',
        role: 'User',
        company: UserCompany.skeleton(),
        address: UserAddress.skeleton(),
      );

  String get fullName => '$firstName $lastName'.trim();
  String get handle => '@$username';
  String get initials =>
      firstName.isNotEmpty ? firstName[0].toUpperCase() : '?';
  String? get formattedRole => role?.toUpperCase();
}
