import 'package:sqflite/sqflite.dart';

import '../../domain/entities/booking.dart';

abstract class BookingRemoteDataSource {
  Future<void> create(Booking booking);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  BookingRemoteDataSourceImpl();

  @override
  Future<void> create(Booking booking) async {
    print('Local');
    var db = await openDatabase('booking.db');
    db.execute('''
          CREATE TABLE bookings (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            account TEXT NOT NULL
          )
          ''');
    print(db);
    throw UnimplementedError();
  }
}
