import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:moneybook/core/consts/database_consts.dart';
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

  // TODO hier weitermachen und weitere Unit Tests implementieren
  group('create Booking in local database', () {
    final Booking tBookingModel = Booking(
      id: 0, // Let SQLite auto-increment the ID
      type: BookingType.expense, // We will convert this to string before inserting
      title: 'Edeka einkaufen',
      date: DateFormat('yyyy-MM-dd').parse('2024-09-25'), // Use DateTime object here
      repetition: RepetitionType.noRepetition, // Convert to string before inserting
      amount: 25.0,
      currency: '€',
      fromAccount: 'Geldbeutel',
      toAccount: '',
      categorie: 'Lebensmittel',
      isBooked: true,
    );
    final tBooking = tBookingModel;

    test('should check if booking was created in local database', () async {
      db = await openDatabase(localDbName);
      await db.execute('DROP TABLE IF EXISTS test_bookings'); // Reset the table

      await db.execute('''
      CREATE TABLE IF NOT EXISTS test_bookings (
        id INTEGER NOT NULL PRIMARY KEY,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        repetition TEXT NOT NULL,
        amount DOUBLE NOT NULL,
        currency TEXT NOT NULL,
        fromAccount TEXT NOT NULL,
        toAccount TEXT NOT NULL,
        categorie TEXT NOT NULL,
        isBooked INTEGER NOT NULL
      )
    ''');

      // Convert enums and DateTime to strings for the database
      final bookingData = {
        'type': 'Ausgabe', // Manually map the BookingType.expense to its string value
        'title': tBooking.title,
        'date': DateFormat('yyyy-MM-dd').format(tBooking.date), // Convert DateTime to string
        'repetition': 'Keine Wiederholung', // Map RepetitionType.noRepetition to its string value
        'amount': tBooking.amount,
        'currency': tBooking.currency,
        'fromAccount': tBooking.fromAccount,
        'toAccount': tBooking.toAccount,
        'categorie': tBooking.categorie,
        'isBooked': tBooking.isBooked ? 1 : 0,
      };

      // Insert the data into the database
      await db.insert('test_bookings', bookingData);

      // Query and validate
      expect(await db.query('test_bookings'), [
        {
          'id': 1, // After insert, expect the id to be auto-incremented (starts at 1)
          'type': 'Ausgabe',
          'title': 'Edeka einkaufen',
          'date': '2024-09-25', // Expect date as a string in 'yyyy-MM-dd' format
          'repetition': 'Keine Wiederholung',
          'amount': 25.0,
          'currency': '€',
          'fromAccount': 'Geldbeutel',
          'toAccount': '',
          'categorie': 'Lebensmittel',
          'isBooked': 1, // Expect 1 for true
        }
      ]);
    });
  });
}
