import 'package:currency_converter_pro/currency_converter_pro.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'currency_converter.g.dart';

abstract class CurrencyConverter {
  const CurrencyConverter();

  Future<double> convertCurrency({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  });

  Future<String> formatToIDR(double amount);
}

class CurrencyConverterImpl implements CurrencyConverter {
  CurrencyConverterImpl([CurrencyConverterPro? converter])
      : _converter = converter ?? CurrencyConverterPro();

  final CurrencyConverterPro _converter;

  @override
  Future<double> convertCurrency({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  }) {
    return _converter.convertCurrency(
      amount: amount,
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
    );
  }

  @override
  Future<String> formatToIDR(double amount) async {
    final convertedAmount = await convertCurrency(
      amount: amount,
      fromCurrency: 'usd',
      toCurrency: 'idr',
    );
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(convertedAmount);
  }
}

@Riverpod(keepAlive: true)
CurrencyConverter currencyConverter(Ref _) {
  return CurrencyConverterImpl();
}

@riverpod
Future<String> formattedIdrPrice(Ref ref, double amount) {
  final converter = ref.watch(currencyConverterProvider);
  return converter.formatToIDR(amount);
}
