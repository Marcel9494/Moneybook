import '../../../../bookings/domain/value_objects/amount_type.dart';
import '../../../../bookings/domain/value_objects/booking_type.dart';

class CategorieStatisticPageArguments {
  final String categorie;
  final BookingType bookingType;
  final DateTime selectedDate;
  final AmountType amountType;

  CategorieStatisticPageArguments(
    this.categorie,
    this.bookingType,
    this.selectedDate,
    this.amountType,
  );
}
