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

  String get description {
    switch (this) {
      case AmountType.undefined:
        return '-';
      case AmountType.buy:
        return 'Wenn ein neues Asset zu deinem Portfolio hinzukommt oder aufgestockt wird.';
      case AmountType.sale:
        return 'Wenn ein Asset dein Portfolio verlässt oder reduziert wird.\n\nBeispiele für Assets:\nAktien, ETFs, Anleihen, Immobilien, Kryptowährungen, ...';
      case AmountType.active:
        return 'Aktive Einnahmen sind Einkünfte, die durch den direkten Einsatz von Zeit, Energie und Arbeit erzielt werden. Bei aktiven Einnahmen wird deine Arbeitskraft oder Zeit gegen Geld getauscht.\nBeispiele: Gehalt als Arbeitnehmer, freiberufliche Tätigkeiten, stundenbasierte Tätigkeiten, ...';
      case AmountType.passive:
        return 'Passive Einnahmen sind Einkommensquellen, bei denen nach einer anfänglichen Investition von Zeit, Geld oder Ressourcen kontinuierlich Geld verdient werden kann, ohne dafür regelmäßig aktiv arbeiten gehen zu müssen.\nBeispiele: Dividenden, Zinsen, Mieteinnahmen, ...';
      case AmountType.fix:
        return 'Fixe Kosten sind Ausgaben die regelmäßig anfallen und sich in der Regel nur selten ändern.\nBeispiele: Miete, Versicherungen, Abos, Kredite, ...';
      case AmountType.variable:
        return 'Variable Kosten sind Ausgaben die sich ändern, je nachdem wieviel du konsumierst.\nBeispiele: Lebensmittel, Restaurants, Kino, Energiekosten, ...';
      case AmountType.overallExpense:
        return '-';
      case AmountType.overallIncome:
        return '-';
      default:
        throw Exception('$name is not a valid Amount type.');
    }
  }
}
