class Amount {
  final double value;
  final String currency;

  Amount({
    required this.value,
    required this.currency,
  });

  static double getValue(String amount) {
    return double.parse(amount.substring(0, amount.length - 2).replaceAll('.', '').replaceAll(',', '.'));
  }

  static String getCurrency(String amount) {
    return amount.substring(amount.length - 1, amount.length);
  }
}
