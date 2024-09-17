import 'package:intl/intl.dart';

// TODO hier weitermachen und formatToMoneyAmount um Centbeträge wegschneiden erweitern
// Beispiel:
// Input moneyAmount: 8.6
// return 8,60 €
String formatToMoneyAmount(String moneyAmount) {
  // TODO 'de-DE' über Einstellungen setzen können und je nach Sprache . ersetzen oder nicht
  var amountFormatter = NumberFormat.simpleCurrency(locale: 'de-DE');
  moneyAmount = amountFormatter.format(double.parse(moneyAmount.replaceAll(',', '.')));
  return moneyAmount;
}

// Beispiel:
// Input amount: 8,60 €
// return 8.6
double formatMoneyAmountToDouble(String amount) {
  return double.parse(amount.substring(0, amount.length - 2).replaceAll('.', '').replaceAll(',', '.'));
}
