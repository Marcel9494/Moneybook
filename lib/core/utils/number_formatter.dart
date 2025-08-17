import 'package:intl/intl.dart';

import '../consts/common_consts.dart';

// Beispiel:
// Input moneyAmount: 8.6
// Input (optional) withoutDecimalPlaces Default Betrag ab 100.000,00 € werden nicht mehr mit Centbeträgen angezeigt.
// Wenn -1 übergeben wird, wird jeder Betrag mit Centbeträgen angegeben.
// return 8,60 €
String formatToMoneyAmount(String moneyAmount, {int withoutDecimalPlaces = 8}) {
  double moneyAmountDouble = double.parse(moneyAmount.replaceAll(',', '.'));
  moneyAmount = moneyAmountDouble.toStringAsFixed(2);
  var amountFormatter =
      NumberFormat.simpleCurrency(locale: locale, decimalDigits: moneyAmount.length > withoutDecimalPlaces && withoutDecimalPlaces != -1 ? 0 : 2);
  moneyAmount = amountFormatter.format(double.parse(moneyAmount));
  return moneyAmount;
}

// Beispiel:
// Input amount: 8,60 € oder $1,345.67
// return 8.6 oder 1345.67
double formatMoneyAmountToDouble(String amount) {
  String cleaned = amount.replaceAll(RegExp(r'[^\d.,-]'), '');

  // Deutsches Format (z.B. "1.234,56")
  if (cleaned.contains(',') && cleaned.indexOf(',') > cleaned.indexOf('.')) {
    cleaned = cleaned.replaceAll('.', '').replaceAll(',', '.');
  }
  // US-Format (z.B. "1,234.56")
  else if (cleaned.contains(',')) {
    cleaned = cleaned.replaceAll(',', '');
  }
  return double.parse(cleaned);
}

double formatPercentToDouble(String percentString) {
  // Entfernt das %-Zeichen und trimmt Leerzeichen
  String cleaned = percentString.replaceAll('%', '').trim();

  // Deutsches Format (z.B. "5,0")
  if (cleaned.contains('.')) {
    cleaned = cleaned.replaceAll('.', ',');
  }
  // US-Format (z.B. "5.0")
  else if (cleaned.contains(',')) {
    cleaned = cleaned.replaceAll(',', '.');
  }
  return double.parse(cleaned);
}

String formatDoubleToPercent(double number) {
  // Entfernt das %-Zeichen und trimmt Leerzeichen
  String percentString = number.toString() + '%';

  // Deutsches Format (z.B. "5,0%")
  if (percentString.contains('.')) {
    percentString = percentString.replaceAll('.', ',');
  }
  // US-Format (z.B. "5.0%")
  else if (percentString.contains(',')) {
    percentString = percentString.replaceAll(',', '.');
  }
  return percentString;
}
