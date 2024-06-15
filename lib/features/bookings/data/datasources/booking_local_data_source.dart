import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/entities/booking.dart';
import '../../domain/value_objects/booking_type.dart';
import '../../domain/value_objects/repetition_type.dart';
import '../models/booking_model.dart';

abstract class BookingLocalDataSource {
  Future<void> create(Booking booking);
  Future<void> edit(Booking booking);
  Future<void> delete(int id);
  Future<BookingModel> load(int id);
  Future<List<Booking>> loadSortedMonthly(DateTime selectedDate);
}

class BookingLocalDataSourceImpl implements BookingLocalDataSource {
  BookingLocalDataSourceImpl();

  static const String bookingDbName = 'bookings';
  var db;

  Future<dynamic> openBookingDatabase(String databaseName) async {
    db = await openDatabase('$databaseName.db', version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE IF NOT EXISTS $databaseName (
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
    return db;
  }

  @override
  Future<void> create(Booking booking) async {
    db = await openBookingDatabase(bookingDbName);
    await db
        .rawInsert('INSERT INTO $bookingDbName(type, title, date, repetition, amount, currency, account, categorie) VALUES(?, ?, ?, ?, ?, ?, ?, ?)', [
      booking.type.name,
      booking.title,
      DateFormat('yyyy-MM-dd').format(booking.date),
      booking.repetition.name,
      booking.amount,
      booking.currency,
      booking.account,
      booking.categorie,
    ]);
  }

  @override
  Future<void> delete(int id) async {
    db = await openBookingDatabase(bookingDbName);
    await db.delete(
      bookingDbName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<BookingModel> load(int id) async {
    // TODO: implement load
    throw UnimplementedError();
  }

  @override
  Future<List<Booking>> loadSortedMonthly(DateTime selectedDate) async {
    await openBookingDatabase(bookingDbName);
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
    bookingList.sort((first, second) => second.date.compareTo(first.date));
    return bookingList;
  }

  @override
  Future<void> edit(Booking booking) async {
    db = await openBookingDatabase(bookingDbName);
    try {
      await db.rawUpdate(
          'UPDATE $bookingDbName SET id = ?, type = ?, title = ?, date = ?, repetition = ?, amount = ?, currency = ?, account = ?, categorie = ? WHERE id = ?',
          [
            booking.id,
            booking.type.name,
            booking.title,
            DateFormat('yyyy-MM-dd').format(booking.date),
            booking.repetition.name,
            booking.amount,
            booking.currency,
            booking.account,
            booking.categorie,
            booking.id
          ]);
    } catch (e) {
      // TODO Fehler richtig behandeln
      print('Error: $e');
    }
  }
}
