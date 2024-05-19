import 'package:sqflite/sqflite.dart';

import '../../domain/entities/booking.dart';

abstract class BookingLocalDataSource {
  Future<void> create(Booking booking);
}

class BookingLocalDataSourceImpl implements BookingLocalDataSource {
  BookingLocalDataSourceImpl();

  @override
  Future<void> create(Booking booking) async {
    print('Local');
    var db = await openDatabase('bookings.db');
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
