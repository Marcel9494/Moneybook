import '../../../../features/bookings/domain/value_objects/amount_type.dart';
import '../../../../features/bookings/domain/value_objects/booking_type.dart';

class BottomNavBarArguments {
  final int tabIndex;
  final DateTime selectedDate;
  final BookingType bookingType;
  final AmountType amountType;

  BottomNavBarArguments({
    required this.tabIndex,
    DateTime? selectedDate,
    BookingType? bookingType,
    AmountType? amountType,
  })  : selectedDate = selectedDate ?? DateTime.now(),
        bookingType = bookingType ?? BookingType.expense,
        amountType = amountType ?? AmountType.overallExpense;
}
