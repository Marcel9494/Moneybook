import 'package:moneybook/features/bookings/domain/entities/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.type,
    required super.title,
    required super.date,
    required super.repetition,
    required super.amount,
    required super.account,
    required super.categorie,
  });
}
