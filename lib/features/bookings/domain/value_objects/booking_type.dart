enum BookingType {
  expense,
  income,
  transfer,
  investment;

  static BookingType fromString(String s) => switch (s) {
        'Ausgabe' => BookingType.expense,
        'Einnahme' => BookingType.income,
        'Übertrag' => BookingType.transfer,
        'Investition' => BookingType.investment,
        _ => BookingType.expense
      };
}

extension BookingTypeExtension on BookingType {
  String get name {
    switch (this) {
      case BookingType.expense:
        return 'Ausgabe';
      case BookingType.income:
        return 'Einnahme';
      case BookingType.transfer:
        return 'Übertrag';
      case BookingType.investment:
        return 'Investition';
      default:
        throw Exception('$name is not a valid Booking type.');
    }
  }

  String get pluralName {
    switch (this) {
      case BookingType.expense:
        return 'Ausgaben';
      case BookingType.income:
        return 'Einnahmen';
      case BookingType.transfer:
        return 'Übertrag';
      case BookingType.investment:
        return 'Investitionen';
      default:
        throw Exception('$name is not a valid Booking type.');
    }
  }
}
