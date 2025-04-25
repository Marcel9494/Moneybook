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

  static AmountType fromString(String amountType) => switch (amountType.toLowerCase()) {
        'undefiniert' => AmountType.undefined,
        'kauf' => AmountType.buy,
        'verkauf' => AmountType.sale,
        'aktiv' => AmountType.active,
        'passiv' => AmountType.passive,
        'fix' => AmountType.fix,
        'variabel' => AmountType.variable,
        'gesamt' => AmountType.overallExpense,
        'gesamt' => AmountType.overallIncome,
        _ => AmountType.undefined
      };
}

extension AmountTypeExtension on AmountType {
  String get name {
    switch (this) {
      case AmountType.undefined:
        return 'undefiniert';
      case AmountType.buy:
        return 'kauf';
      case AmountType.sale:
        return 'verkauf';
      case AmountType.active:
        return 'aktiv';
      case AmountType.passive:
        return 'passiv';
      case AmountType.fix:
        return 'fix';
      case AmountType.variable:
        return 'variabel';
      case AmountType.overallExpense:
        return 'gesamt';
      case AmountType.overallIncome:
        return 'gesamt';
    }
  }

  String get description {
    switch (this) {
      case AmountType.undefined:
        return '-';
      case AmountType.buy:
        return 'kauf_beschreibung';
      case AmountType.sale:
        return 'verkauf_beschreibung';
      case AmountType.active:
        return 'aktiv_beschreibung';
      case AmountType.passive:
        return 'passiv_beschreibung';
      case AmountType.fix:
        return 'fix_beschreibung';
      case AmountType.variable:
        return 'variabel_beschreibung';
      case AmountType.overallExpense:
        return '-';
      case AmountType.overallIncome:
        return '-';
    }
  }
}
