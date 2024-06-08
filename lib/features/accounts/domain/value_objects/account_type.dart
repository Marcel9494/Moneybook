enum AccountType {
  none,
  account,
  capitalInvestment,
  cash,
  card,
  insurance,
  credit,
  other;
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
