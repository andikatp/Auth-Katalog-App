import 'package:intl/intl.dart';

extension NullableStringCleaner on String? {
  String cleanOrDefault([String defaultValue = '-']) {
    final value = this?.trim();
    return value == null || value.isEmpty ? defaultValue : value;
  }

  String get clean => cleanOrDefault();
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
