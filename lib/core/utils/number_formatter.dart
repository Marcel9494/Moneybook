import 'package:intl/intl.dart';

// Beispiel:
// Input moneyAmount: 8.6
// return 8,60 €
String formatToMoneyAmount(String moneyAmount) {
  // TODO 'de-DE' über Einstellungen setzen können und je nach Sprache . ersetzen oder nicht
  var amountFormatter = NumberFormat.simpleCurrency(locale: 'de-DE');
  moneyAmount = amountFormatter.format(double.parse(moneyAmount.replaceAll(',', '.')));
  return moneyAmount;
}
