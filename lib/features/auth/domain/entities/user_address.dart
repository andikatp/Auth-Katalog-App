import 'package:auth_katalog_app/core/extensions/string_extensions.dart';
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

  const UserAddress._();

  factory UserAddress.fromJson(Map<String, dynamic> json) =>
      _$UserAddressFromJson(json);

  factory UserAddress.skeleton() => const UserAddress(
        address: '123 Main Street',
        city: 'City',
        state: 'State',
        country: 'Country',
      );

  String get locationSummary {
    return [
      city.clean,
      state.clean,
      country.clean,
    ].where((part) => part != '-').join(', ').clean;
  }
}
