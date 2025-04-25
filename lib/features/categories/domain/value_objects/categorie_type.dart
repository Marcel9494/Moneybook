enum CategorieType {
  expense,
  income,
  investment;

  static CategorieType fromString(String s) => switch (s) {
        'Ausgabe' || 'ausgabe' => CategorieType.expense,
        'Einnahme' || 'einnahme' => CategorieType.income,
        'Investition' || 'investition' => CategorieType.investment,
        _ => CategorieType.expense
      };
}

extension CategorieTypeExtension on CategorieType {
  String get name {
    switch (this) {
      case CategorieType.expense:
        return 'ausgabe';
      case CategorieType.income:
        return 'einnahme';
      case CategorieType.investment:
        return 'investition';
    }
  }

  String get pluralName {
    switch (this) {
      case CategorieType.expense:
        return 'ausgaben';
      case CategorieType.income:
        return 'einnahmen';
      case CategorieType.investment:
        return 'investitionen';
    }
  }
}
