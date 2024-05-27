enum BookingType { expense, income, transfer, investment }

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
}
