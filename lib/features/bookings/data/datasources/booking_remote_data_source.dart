import 'package:sqflite/sqflite.dart';

import '../../domain/entities/booking.dart';
import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<void> create(Booking booking);
  Future<void> update(Booking booking);
  Future<void> delete(int id);
  Future<BookingModel> get(int id);
  Future<List<BookingModel>> getAll();
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  BookingRemoteDataSourceImpl();

  @override
  Future<void> create(Booking booking) async {
    print("Booking: $booking");
    final String bookingDbName = 'booking';
    databaseFactory.deleteDatabase('$bookingDbName.db');
    var db = await openDatabase('$bookingDbName.db');
    db.execute('''
          CREATE TABLE $bookingDbName (
            id INTEGER PRIMARY KEY,
            type TEXT NOT NULL,
            title TEXT NOT NULL,
            date TEXT NOT NULL,
            amount DOUBLE NOT NULL,
            account TEXT NOT NULL,
            categorie TEXT NOT NULL
          )
          ''');
    db.rawInsert('INSERT INTO $bookingDbName(id, type, title, date, amount, account, categorie) VALUES(?, ?, ?, ?, ?, ?, ?)', [
      booking.id,
      booking.type.name,
      booking.title,
      booking.date.toString(),
      booking.amount,
      booking.account,
      booking.categorie,
    ]);
    //db.delete('bookings');
    print(db);
    print('Success');
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
