enum AmountType {
  undefined,
  buy,
  sale,
  active,
  passive,
  fix,
  variable,
  overallExpense,
  overallIncome;

  static AmountType fromString(String s) => switch (s) {
        'Undefiniert' => AmountType.undefined,
        'Kauf' => AmountType.buy,
        'Verkauf' => AmountType.sale,
        'Aktiv' => AmountType.active,
        'Passiv' => AmountType.passive,
        'Fix' => AmountType.fix,
        'Variabel' => AmountType.variable,
        'Gesamt' => AmountType.overallExpense,
        'Gesamt' => AmountType.overallIncome,
        _ => AmountType.undefined
      };
}

extension AmountTypeExtension on AmountType {
  String get name {
    switch (this) {
      case AmountType.undefined:
        return 'Undefiniert';
      case AmountType.buy:
        return 'Kauf';
      case AmountType.sale:
        return 'Verkauf';
      case AmountType.active:
        return 'Aktiv';
      case AmountType.passive:
        return 'Passiv';
      case AmountType.fix:
        return 'Fix';
      case AmountType.variable:
        return 'Variabel';
      case AmountType.overallExpense:
        return 'Gesamt';
      case AmountType.overallIncome:
        return 'Gesamt';
      default:
        throw Exception('$name is not a valid Amount type.');
    }
  }
}
