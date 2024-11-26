import 'package:intl/intl.dart';

import '../consts/common_consts.dart';

// Beispiel:
// Input moneyAmount: 8.6
// Input (optional) withoutDecimalPlaces Default Betrag ab 100.000,00 € werden nicht mehr mit Centbeträgen angezeigt
// return 8,60 €
String formatToMoneyAmount(String moneyAmount, {int withoutDecimalPlaces = 8}) {
  double moneyAmountDouble = double.parse(moneyAmount.replaceAll(',', '.'));
  moneyAmount = moneyAmountDouble.toStringAsFixed(2);
  var amountFormatter = NumberFormat.simpleCurrency(locale: locale, decimalDigits: moneyAmount.length > withoutDecimalPlaces ? 0 : 2);
  moneyAmount = amountFormatter.format(double.parse(moneyAmount));
  return moneyAmount;
}

// Beispiel:
// Input amount: 8,60 €
// return 8.6
double formatMoneyAmountToDouble(String amount) {
  return double.parse(amount.substring(0, amount.length - 2).replaceAll('.', '').replaceAll(',', '.'));
}
