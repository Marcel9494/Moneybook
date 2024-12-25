import 'package:moneybook/core/consts/regex_consts.dart';

import '../../../../core/consts/common_consts.dart';

class Amount {
  final double value;
  final String currency;

  Amount({
    required this.value,
    required this.currency,
  });

  // Beispiel:
  // Input amount: 8,60 €
  // Zuerst wird überprüft, ob der String ein gültiges currencySymbol enthält (€, $, etc.)
  // Wenn dies nicht der Fall ist wird die Zahl nur in eine double geparst und zurückgegeben, weil
  // dann schon das richtige Format vorliegt. Wenn ein currencySymbol enthalten ist
  // werden alle nicht Zahlen, Kommas und Punkte vom String entfernt.
  // Anschließend werden Kommas (,) durch Punkte (.) ersetzt.
  // return 8.6
  static double getValue(String amount) {
    for (String currencySymbol in currencySymbols) {
      if (amount.contains(currencySymbol)) {
        String cleanedAmount = amount.replaceAll(numberRegex, '');
        cleanedAmount = cleanedAmount.replaceAll('.', '').replaceAll(',', '.');
        return double.parse(cleanedAmount);
      }
    }
    return double.parse(amount);
  }

  // Beispiel:
  // Input amount: 8,60 € oder $8.60
  // Der String wird nach einem gültigen currencySymbol durchsucht (€, $, etc.) und zurückgegeben
  // return € oder $
  static String getCurrency(String amount) {
    for (String currencySymbol in currencySymbols) {
      if (amount.contains(currencySymbol)) {
        return currencySymbol;
      }
    }
    return currencyLocale;
  }
}
