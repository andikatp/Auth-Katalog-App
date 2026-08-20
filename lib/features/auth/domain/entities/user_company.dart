import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_company.freezed.dart';
part 'user_company.g.dart';

@freezed
sealed class UserCompany with _$UserCompany {
  const factory UserCompany({
    String? name,
    String? department,
    String? title,
  }) = _UserCompany;

  factory UserCompany.fromJson(Map<String, dynamic> json) =>
      _$UserCompanyFromJson(json);
}
