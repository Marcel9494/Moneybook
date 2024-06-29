enum AccountType {
  none,
  account,
  capitalInvestment,
  cash,
  card,
  insurance,
  credit,
  other;

  static AccountType fromString(String s) => switch (s) {
        'Kein Kontotyp ausgewählt' => AccountType.none,
        'Konto' => AccountType.account,
        'Kapitalanlage' => AccountType.capitalInvestment,
        'Bargeld' => AccountType.cash,
        'Karte' => AccountType.card,
        'Versicherung' => AccountType.insurance,
        'Kredit' => AccountType.credit,
        'Sonstiges' => AccountType.other,
        _ => AccountType.none
      };
}

extension AccountTypeExtension on AccountType {
  String get name {
    switch (this) {
      case AccountType.none:
        return 'Kein Kontotyp ausgewählt';
      case AccountType.account:
        return 'Konto';
      case AccountType.capitalInvestment:
        return 'Kapitalanlage';
      case AccountType.cash:
        return 'Bargeld';
      case AccountType.card:
        return 'Karte';
      case AccountType.insurance:
        return 'Versicherung';
      case AccountType.credit:
        return 'Kredit';
      case AccountType.other:
        return 'Sonstiges';
      default:
        throw Exception('$name is not a valid Account type.');
    }
  }
}
