import 'package:sqflite/sqflite.dart';

import '../../domain/entities/booking.dart';
import '../models/booking_model.dart';

abstract class BookingLocalDataSource {
  Future<void> create(Booking booking);
  Future<void> update(Booking booking);
  Future<void> delete(int id);
  Future<BookingModel> get(int id);
  Future<List<BookingModel>> getAll();
}

class BookingLocalDataSourceImpl implements BookingLocalDataSource {
  BookingLocalDataSourceImpl();

  static const String bookingDbName = 'booking';

  @override
  Future<void> create(Booking booking) async {
    // TODO entfernen, sobald delete Funktionalität implementiert ist
    print("Booking: $booking");
    databaseFactory.deleteDatabase('$bookingDbName.db');
    var db = await openDatabase('$bookingDbName.db');
    // TODO Create Table in eigene Funktionalität packen, wenn App gestartet wird aufrufen, wenn
    // TODO die Tabelle noch nicht erstellt wurde.
    db.execute('''
          CREATE TABLE $bookingDbName (
            id INTEGER PRIMARY KEY,
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
    db.rawInsert(
        'INSERT INTO $bookingDbName(id, type, title, date, repetition, amount, currency, account, categorie) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)', [
      booking.id,
      booking.type.name,
      booking.title,
      booking.date.toString(),
      booking.repetition.name,
      booking.amount.value,
      booking.amount.currency,
      booking.account,
      booking.categorie,
    ]);
  }

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<BookingModel> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<BookingModel>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<void> update(Booking booking) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
