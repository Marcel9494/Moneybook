import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:moneybook/features/bookings/data/datasources/booking_local_data_source.dart';
import 'package:moneybook/features/bookings/domain/entities/booking.dart';
import 'package:moneybook/features/bookings/domain/value_objects/booking_type.dart';
import 'package:moneybook/features/bookings/domain/value_objects/repetition_type.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late BookingLocalDataSourceImpl bookingLocalDataSource;

  setUp(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    bookingLocalDataSource = BookingLocalDataSourceImpl();
  });

  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  group('create Booking in local database', () {
    final Booking tBookingModel = Booking(
      id: 0,
      type: BookingType.expense,
      title: 'Edeka einkaufen',
      date: DateTime.parse(currentDate),
      repetition: RepetitionType.noRepetition,
      amount: 25.0,
      currency: '€',
      fromAccount: 'Geldbeutel',
      toAccount: '',
      categorie: 'Lebensmittel',
    );
    final tBooking = tBookingModel;

    test('should check if booking was created in local database', () async {
      var db = await bookingLocalDataSource.openBookingDatabase('test_bookings');
      //var db = await openDatabase('test_bookings.db', version: 1);
      //db.rawDelete('DELETE FROM test_bookings');
      //db.rawDelete('DELETE FROM id where name=test_bookings');
      //db.delete('bookings');
      bookingLocalDataSource.create(tBooking);
      expect(await db.query('test_bookings'), [
        {
          'id': 0,
          'type': 'Ausgabe',
          'title': 'Edeka einkaufen',
          'date': currentDate,
          'repetition': 'Keine Wiederholung',
          'amount': 25.0,
          'currency': '€',
          'account': 'Geldbeutel',
          'categorie': 'Lebensmittel',
        }
      ]);
    });
  });
}
