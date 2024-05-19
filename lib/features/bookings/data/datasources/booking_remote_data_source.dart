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
    print('Remote');
    final String bookingDbName = 'booking';
    final String title = 'Titel';
    final String account = 'Account';
    databaseFactory.deleteDatabase('$bookingDbName.db');
    var db = await openDatabase('$bookingDbName.db');
    db.execute('''
          CREATE TABLE $bookingDbName (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            account TEXT NOT NULL
          )
          ''');
    db.rawInsert('INSERT INTO $bookingDbName(title, account) VALUES(?, ?)', [title, account]);
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
