enum CategorieType {
  expense,
  income,
  investment;

  static CategorieType fromString(String s) => switch (s) {
        'Ausgabe' => CategorieType.expense,
        'Einnahme' => CategorieType.income,
        'Investment' => CategorieType.investment,
        _ => CategorieType.expense
      };
}

extension CategorieTypeExtension on CategorieType {
  String get name {
    switch (this) {
      case CategorieType.expense:
        return 'Ausgabe';
      case CategorieType.income:
        return 'Einnahme';
      case CategorieType.investment:
        return 'Investment';
      default:
        throw Exception('$name is not a valid Categorie type.');
    }
  }
}
