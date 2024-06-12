enum CategorieType {
  outcome,
  income,
  investment;
}

extension CategorieTypeExtension on CategorieType {
  String get name {
    switch (this) {
      case CategorieType.outcome:
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
