class CurrencyHelper {
  static Map<String, String> currencyMap = {
    'de': '€',
    'en': '\$',
  };

  static String getCurrencyFromCountry(String countryCode) {
    return currencyMap[countryCode] ?? '\$';
  }
}
