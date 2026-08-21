import 'package:intl/intl.dart';

extension NullableStringCleaner on String? {
  String cleanOrDefault([String defaultValue = '-']) {
    final value = this?.trim();
    return value == null || value.isEmpty ? defaultValue : value;
  }

  String get clean => cleanOrDefault();
}

extension NullableNumCleaner on num? {
  String cleanUnit(String unit, [String defaultValue = '-']) {
    if (this == null) return defaultValue;
    return '$this $unit';
  }
}

extension NullableDateStringFormatter on String? {
  String readableDateOrDefault([String defaultValue = '-']) {
    final value = cleanOrDefault(defaultValue);
    if (value == defaultValue) return defaultValue;

    final date = DateTime.tryParse(value);
    if (date == null) return value;

    return DateFormat('d MMM yyyy').format(date);
  }

  String get readableDate => readableDateOrDefault();
}
