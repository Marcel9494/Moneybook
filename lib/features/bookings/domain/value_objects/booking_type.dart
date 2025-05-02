enum BookingType {
  none,
  expense,
  income,
  transfer,
  investment;

  static BookingType fromString(String s) => switch (s) {
        '' => BookingType.none,
        'Ausgabe' || 'ausgabe' => BookingType.expense,
        'Einnahme' || 'einnahme' => BookingType.income,
        'Übertrag' || 'übertrag' => BookingType.transfer,
        'Investition' || 'investition' => BookingType.investment,
        _ => BookingType.expense
      };
}

extension BookingTypeExtension on BookingType {
  String get name {
    switch (this) {
      case BookingType.none:
        return '';
      case BookingType.expense:
        return 'Ausgabe';
      case BookingType.income:
        return 'Einnahme';
      case BookingType.transfer:
        return 'Übertrag';
      case BookingType.investment:
        return 'Investition';
    }
  }

  String get pluralName {
    switch (this) {
      case BookingType.none:
        return '';
      case BookingType.expense:
        return 'Ausgaben';
      case BookingType.income:
        return 'Einnahmen';
      case BookingType.transfer:
        return 'Übertrag';
      case BookingType.investment:
        return 'Investitionen';
    }
  }
}
