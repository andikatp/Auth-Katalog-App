import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_address.freezed.dart';
part 'user_address.g.dart';

@freezed
sealed class UserAddress with _$UserAddress {
  const factory UserAddress({
    String? address,
    String? city,
    String? state,
    String? country,
  }) = _UserAddress;

  factory UserAddress.fromJson(Map<String, dynamic> json) =>
      _$UserAddressFromJson(json);
}
