import 'package:flutter_test/flutter_test.dart';
import 'package:moneybook/features/bookings/data/models/booking_model.dart';
import 'package:moneybook/features/bookings/domain/entities/booking.dart';
import 'package:moneybook/features/bookings/domain/value_objects/booking_type.dart';
import 'package:moneybook/features/bookings/domain/value_objects/repetition_type.dart';

void main() {
  final tBookingModel = BookingModel(
    id: 0,
    type: BookingType.expense,
    title: 'Edeka einkaufen',
    date: DateTime.now(),
    repetition: RepetitionType.noRepetition,
    amount: 25.0,
    currency: '€',
    account: 'Geldbeutel',
    categorie: 'Lebensmittel',
  );

  test('should be a subclass of Booking entity', () async {
    expect(tBookingModel, isA<Booking>());
  });
}
