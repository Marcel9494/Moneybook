import 'package:intl/intl.dart';
import 'package:moneybook/core/consts/database_consts.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../categories/domain/value_objects/categorie_type.dart';
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
  Future<List<Booking>> loadCategorieBookings(String categorie);
  Future<List<Booking>> loadNewBookings();
  Future<void> updateAllBookingsWithCategorie(String oldCategorie, String newCategorie, CategorieType categorieType);
  Future<void> updateAllBookingsWithAccount(String oldAccount, String newAccount);
  Future<void> checkForNewBookings();
}

class BookingLocalDataSourceImpl implements BookingLocalDataSource {
  BookingLocalDataSourceImpl();

  @override
  Future<void> create(Booking booking) async {
    db = await openDatabase(localDbName);
    await db.rawInsert(
      'INSERT INTO $bookingDbName(type, title, date, repetition, amount, currency, fromAccount, toAccount, categorie, isBooked) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        booking.type.name,
        booking.title,
        dateFormatterYYYYMMDD.format(booking.date),
        booking.repetition.name,
        booking.amount,
        booking.currency,
        booking.fromAccount,
        booking.toAccount,
        booking.categorie,
        booking.isBooked,
      ],
    );
  }

  @override
  Future<void> edit(Booking booking) async {
    db = await openDatabase(localDbName);
    try {
      await db.rawUpdate(
          'UPDATE $bookingDbName SET id = ?, type = ?, title = ?, date = ?, repetition = ?, amount = ?, currency = ?, fromAccount = ?, toAccount = ?, categorie = ?, isBooked = ? WHERE id = ?',
          [
            booking.id,
            booking.type.name,
            booking.title,
            DateFormat('yyyy-MM-dd').format(booking.date),
            booking.repetition.name,
            booking.amount,
            booking.currency,
            booking.fromAccount,
            booking.toAccount,
            booking.categorie,
            booking.isBooked,
            booking.id,
          ]);
    } catch (e) {
      // TODO Fehler richtig behandeln
      print('Error: $e');
    }
  }

  @override
  Future<void> delete(int id) async {
    db = await openDatabase(localDbName);
    await db.rawDelete('DELETE FROM $bookingDbName WHERE id = ?', [id]);
  }

  @override
  Future<BookingModel> load(int id) async {
    // TODO: implement load
    throw UnimplementedError();
  }

  @override
  Future<List<Booking>> loadSortedMonthly(DateTime selectedDate) async {
    db = await openDatabase(localDbName);
    int lastday = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    String startDate = dateFormatterYYYYMMDD.format(DateTime(selectedDate.year, selectedDate.month, 1));
    String endDate = dateFormatterYYYYMMDD.format(DateTime(selectedDate.year, selectedDate.month, lastday));
    List<Map> bookingMap = await db.rawQuery('SELECT * FROM $bookingDbName WHERE date BETWEEN ? AND ?', [startDate, endDate]);
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
            fromAccount: booking['fromAccount'],
            toAccount: booking['toAccount'],
            categorie: booking['categorie'],
            isBooked: booking['isBooked'] == 0 ? false : true,
          ),
        )
        .toList();
    bookingList.sort((first, second) => second.date.compareTo(first.date));
    return bookingList;
  }

  @override
  Future<List<Booking>> loadCategorieBookings(String categorie) async {
    db = await openDatabase(localDbName);
    List<Map> categorieBookingMap = await db.rawQuery('SELECT * FROM $bookingDbName WHERE categorie = ?', [categorie]);
    List<Booking> categorieBookingList = categorieBookingMap
        .map(
          (booking) => Booking(
            id: booking['id'],
            type: BookingType.fromString(booking['type']),
            title: booking['title'],
            date: DateTime.parse(booking['date']),
            repetition: RepetitionType.fromString(booking['repetition']),
            amount: booking['amount'],
            currency: booking['currency'],
            fromAccount: booking['fromAccount'],
            toAccount: booking['toAccount'],
            categorie: booking['categorie'],
            isBooked: booking['isBooked'] == 0 ? false : true,
          ),
        )
        .toList();
    return categorieBookingList;
  }

  @override
  Future<void> updateAllBookingsWithCategorie(String oldCategorie, String newCategorie, CategorieType categorieType) async {
    db = await openDatabase(localDbName);
    await db.rawUpdate(
        'UPDATE $bookingDbName SET categorie = ? WHERE categorie = ? AND type = ?', [newCategorie, oldCategorie, categorieType.name.trim()]);
  }

  @override
  Future<void> updateAllBookingsWithAccount(String oldAccount, String newAccount) async {
    db = await openDatabase(localDbName);
    await db.rawUpdate('UPDATE $bookingDbName SET fromAccount = ? WHERE fromAccount = ?', [newAccount, oldAccount]);
    await db.rawUpdate('UPDATE $bookingDbName SET toAccount = ? WHERE toAccount = ?', [newAccount, oldAccount]);
  }

  @override
  Future<void> checkForNewBookings() async {
    db = await openDatabase(localDbName);
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    await db.rawUpdate('UPDATE $bookingDbName SET isBooked = ? WHERE date <= ?', [1/*= true*/, today.toIso8601String()]);
  }

  @override
  Future<List<Booking>> loadNewBookings() async {
    db = await openDatabase(localDbName);
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    List<Map> newBookingMap =
        await db.rawQuery('SELECT * FROM $bookingDbName WHERE isBooked = ? AND date <= ?', [0/*= false*/, today.toIso8601String()]);
    List<Booking> newBookingList = newBookingMap
        .map(
          (booking) => Booking(
            id: booking['id'],
            type: BookingType.fromString(booking['type']),
            title: booking['title'],
            date: DateTime.parse(booking['date']),
            repetition: RepetitionType.fromString(booking['repetition']),
            amount: booking['amount'],
            currency: booking['currency'],
            fromAccount: booking['fromAccount'],
            toAccount: booking['toAccount'],
            categorie: booking['categorie'],
            isBooked: booking['isBooked'] == 0 ? false : true,
          ),
        )
        .toList();
    return newBookingList;
  }
}
