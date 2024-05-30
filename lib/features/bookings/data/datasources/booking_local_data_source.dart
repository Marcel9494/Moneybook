import 'package:sqflite/sqflite.dart';

import '../../domain/entities/booking.dart';
import '../../domain/value_objects/booking_type.dart';
import '../../domain/value_objects/repetition_type.dart';
import '../models/booking_model.dart';

abstract class BookingLocalDataSource {
  Future<void> create(Booking booking);
  Future<void> update(Booking booking);
  Future<void> delete(int id);
  Future<BookingModel> load(int id);
  Future<List<Booking>> loadMonthly(DateTime selectedDate);
}

class BookingLocalDataSourceImpl implements BookingLocalDataSource {
  BookingLocalDataSourceImpl();

  static const String bookingDbName = 'bookings';
  var db;

  Future<void> openBookingDatabase() async {
    db = await openDatabase('$bookingDbName.db', version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE IF NOT EXISTS $bookingDbName (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            type TEXT NOT NULL,
            title TEXT NOT NULL,
            date TEXT NOT NULL,
            repetition TEXT NOT NULL,
            amount DOUBLE NOT NULL,
            currency TEXT NOT NULL,
            account TEXT NOT NULL,
            categorie TEXT NOT NULL
          )
          ''');
    });
  }

  @override
  Future<void> create(Booking booking) async {
    await openBookingDatabase();
    await db
        .rawInsert('INSERT INTO $bookingDbName(type, title, date, repetition, amount, currency, account, categorie) VALUES(?, ?, ?, ?, ?, ?, ?, ?)', [
      booking.type.name,
      booking.title,
      booking.date.toString(),
      booking.repetition.name,
      booking.amount,
      booking.currency,
      booking.account,
      booking.categorie,
    ]);
  }

  @override
  Future<void> delete(int id) async {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<BookingModel> load(int id) async {
    // TODO: implement load
    throw UnimplementedError();
  }

  @override
  Future<List<Booking>> loadMonthly(DateTime selectedDate) async {
    await openBookingDatabase();
    List<Map> bookingMap = await db.rawQuery('SELECT * FROM $bookingDbName');
    List<Booking> bookingList = bookingMap
        .map(
          (booking) => Booking(
            id: booking['id'],
            type: BookingType.fromString(booking['type']),
            title: booking['title'],
            date: DateTime.parse(booking['date']),
            repetition: RepetitionType.fromString(booking['repetition']),
            amount: booking['amount'],
            currency: booking['currency'],
            account: booking['account'],
            categorie: booking['categorie'],
          ),
        )
        .toList();
    print(bookingList);
    return bookingList;
  }

  @override
  Future<void> update(Booking booking) async {
    // TODO: implement update
    throw UnimplementedError();
  }
}
