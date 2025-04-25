enum AccountType {
  none,
  account,
  capitalInvestment,
  cash,
  card,
  insurance,
  credit,
  other;

  static AccountType fromString(String accountType) => switch (accountType.toLowerCase()) {
        'kein kontotyp ausgewählt' || 'kein_kontotyp_ausgewählt' => AccountType.none,
        'konto' => AccountType.account,
        'kapitalanlage' => AccountType.capitalInvestment,
        'bargeld' => AccountType.cash,
        'karte' => AccountType.card,
        'versicherung' => AccountType.insurance,
        'kredit' => AccountType.credit,
        'sonstiges' => AccountType.other,
        _ => AccountType.none
      };
}

extension AccountTypeExtension on AccountType {
  String get name {
    switch (this) {
      case AccountType.none:
        return 'kein_kontotyp_ausgewählt';
      case AccountType.account:
        return 'konto';
      case AccountType.capitalInvestment:
        return 'kapitalanlage';
      case AccountType.cash:
        return 'bargeld';
      case AccountType.card:
        return 'karte';
      case AccountType.insurance:
        return 'versicherung';
      case AccountType.credit:
        return 'kredit';
      case AccountType.other:
        return 'sonstiges';
    }
  }

  String get pluralName {
    switch (this) {
      case AccountType.none:
        return 'kein_kontotyp_ausgewählt';
      case AccountType.account:
        return 'konten';
      case AccountType.capitalInvestment:
        return 'kapitalanlagen';
      case AccountType.cash:
        return 'bargeld';
      case AccountType.card:
        return 'karten';
      case AccountType.insurance:
        return 'versicherungen';
      case AccountType.credit:
        return 'kredite';
      case AccountType.other:
        return 'sonstiges';
    }
  }
}
