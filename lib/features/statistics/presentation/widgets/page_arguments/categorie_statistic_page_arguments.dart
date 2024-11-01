import '../../../../bookings/domain/value_objects/booking_type.dart';

class CategorieStatisticPageArguments {
  final String categorie;
  final BookingType bookingType;
  final DateTime selectedDate;

  CategorieStatisticPageArguments(
    this.categorie,
    this.bookingType,
    this.selectedDate,
  );
}
