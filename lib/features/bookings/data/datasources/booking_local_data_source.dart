import 'package:intl/intl.dart';
import 'package:moneybook/core/consts/database_consts.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../categories/domain/value_objects/categorie_type.dart';
import '../../domain/entities/booking.dart';
import '../../domain/value_objects/amount_type.dart';
import '../../domain/value_objects/booking_type.dart';
import '../../domain/value_objects/repetition_type.dart';
import '../models/booking_model.dart';

abstract class BookingLocalDataSource {
  Future<void> create(Booking booking);
  Future<void> update(Booking booking);
  Future<void> delete(int id);
  Future<void> deleteAllBookingsInSerie(int serieId);
  Future<void> deleteOnlyFutureBookingsInSerie(int serieId, DateTime from);
  Future<BookingModel> load(int id);
  Future<List<Booking>> loadSortedMonthly(DateTime selectedDate);
  Future<List<Booking>> loadMonthlyAmountTypeBookings(DateTime selectedDate, AmountType amountType);
  Future<List<Booking>> loadCategorieBookings(String categorie);
  Future<List<Booking>> loadPastMonthlyCategorieBookings(String categorie, DateTime date, int monthNumber);
  Future<List<Booking>> loadNewBookings();
  Future<List<Booking>> loadSerieBookings(int serieId);
  Future<void> updateAllBookingsWithCategorie(String oldCategorie, String newCategorie, CategorieType categorieType);
  Future<void> updateAllBookingsWithAccount(String oldAccount, String newAccount);
  Future<List<Booking>> updateAllBookingsInSerie(Booking updatedBooking, List<Booking> serieBookings);
  Future<List<Booking>> updateOnlyFutureBookingsInSerie(Booking updatedBooking, List<Booking> serieBookings);
  Future<void> checkForNewBookings();
  Future<int> getNewSerieId();
}

class BookingLocalDataSourceImpl implements BookingLocalDataSource {
  BookingLocalDataSourceImpl();

  @override
  Future<void> create(Booking booking) async {
    db = await openDatabase(localDbName);
    await db.rawInsert(
      'INSERT INTO $bookingDbName(serieId, type, title, date, repetition, amount, amountType, currency, fromAccount, toAccount, categorie, isBooked) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        booking.serieId,
        booking.type.name,
        booking.title,
        dateFormatterYYYYMMDD.format(booking.date),
        booking.repetition.name,
        booking.amount,
        booking.amountType.name,
        booking.currency,
        booking.fromAccount,
        booking.toAccount,
        booking.categorie,
        booking.isBooked,
      ],
    );
  }

  @override
  Future<void> update(Booking booking) async {
    db = await openDatabase(localDbName);
    try {
      await db.rawUpdate(
        'UPDATE $bookingDbName SET id = ?, serieId = ?, type = ?, title = ?, date = ?, repetition = ?, amount = ?, amountType = ?, currency = ?, fromAccount = ?, toAccount = ?, categorie = ?, isBooked = ? WHERE id = ?',
        [
          booking.id,
          booking.serieId,
          booking.type.name,
          booking.title,
          DateFormat('yyyy-MM-dd').format(booking.date),
          booking.repetition.name,
          booking.amount,
          booking.amountType.name,
          booking.currency,
          booking.fromAccount,
          booking.toAccount,
          booking.categorie,
          booking.isBooked ? 1 : 0,
          booking.id,
        ],
      );
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
  Future<void> deleteAllBookingsInSerie(int serieId) async {
    db = await openDatabase(localDbName);
    await db.rawDelete('DELETE FROM $bookingDbName WHERE serieId = ?', [serieId]);
  }

  @override
  Future<void> deleteOnlyFutureBookingsInSerie(int serieId, DateTime from) async {
    db = await openDatabase(localDbName);
    await db.rawDelete('DELETE FROM $bookingDbName WHERE serieId = ? AND date > ?', [serieId, from.toIso8601String()]);
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
            serieId: booking['serieId'],
            type: BookingType.fromString(booking['type']),
            title: booking['title'],
            date: DateTime.parse(booking['date']),
            repetition: RepetitionType.fromString(booking['repetition']),
            amount: booking['amount'],
            amountType: AmountType.fromString(booking['amountType']),
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
  Future<List<Booking>> loadMonthlyAmountTypeBookings(DateTime selectedDate, AmountType amountType) async {
    db = await openDatabase(localDbName);
    List<Map> bookingMap;
    int lastday = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    String startDate = dateFormatterYYYYMMDD.format(DateTime(selectedDate.year, selectedDate.month, 1));
    String endDate = dateFormatterYYYYMMDD.format(DateTime(selectedDate.year, selectedDate.month, lastday));
    if (AmountType.overallExpense == amountType || AmountType.overallIncome == amountType) {
      bookingMap = await db.rawQuery('SELECT * FROM $bookingDbName WHERE date BETWEEN ? AND ?', [startDate, endDate]);
    } else {
      bookingMap =
          await db.rawQuery('SELECT * FROM $bookingDbName WHERE date BETWEEN ? AND ? AND amountType = ?', [startDate, endDate, amountType.name]);
    }
    List<Booking> bookingList = bookingMap
        .map(
          (booking) => Booking(
            id: booking['id'],
            serieId: booking['serieId'],
            type: BookingType.fromString(booking['type']),
            title: booking['title'],
            date: DateTime.parse(booking['date']),
            repetition: RepetitionType.fromString(booking['repetition']),
            amount: booking['amount'],
            amountType: AmountType.fromString(booking['amountType']),
            currency: booking['currency'],
            fromAccount: booking['fromAccount'],
            toAccount: booking['toAccount'],
            categorie: booking['categorie'],
            isBooked: booking['isBooked'] == 0 ? false : true,
          ),
        )
        .toList();
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
            serieId: booking['serieId'],
            type: BookingType.fromString(booking['type']),
            title: booking['title'],
            date: DateTime.parse(booking['date']),
            repetition: RepetitionType.fromString(booking['repetition']),
            amount: booking['amount'],
            amountType: AmountType.fromString(booking['amountType']),
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

  Future<List<Booking>> loadPastMonthlyCategorieBookings(String categorie, DateTime date, int monthNumber) async {
    db = await openDatabase(localDbName);
    int lastday = DateTime(date.year, date.month + 1, 0).day;
    String startDate = dateFormatterYYYYMMDD.format(DateTime(date.year, date.month - (monthNumber - 1), 1));
    String endDate = dateFormatterYYYYMMDD.format(DateTime(date.year, date.month, lastday));
    List<Map> categorieBookingMap =
        await db.rawQuery('SELECT * FROM $bookingDbName WHERE categorie = ? AND date BETWEEN ? AND ?', [categorie, startDate, endDate]);

    List<Booking> categorieBookingList = categorieBookingMap
        .map(
          (booking) => Booking(
            id: booking['id'],
            serieId: booking['serieId'],
            type: BookingType.fromString(booking['type']),
            title: booking['title'],
            date: DateTime.parse(booking['date']),
            repetition: RepetitionType.fromString(booking['repetition']),
            amount: booking['amount'],
            amountType: AmountType.fromString(booking['amountType']),
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
            serieId: booking['serieId'],
            type: BookingType.fromString(booking['type']),
            title: booking['title'],
            date: DateTime.parse(booking['date']),
            repetition: RepetitionType.fromString(booking['repetition']),
            amount: booking['amount'],
            amountType: booking['amountType'],
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

  @override
  Future<List<Booking>> loadSerieBookings(int serieId) async {
    db = await openDatabase(localDbName);
    List<Map> serieBookingMap = await db.rawQuery('SELECT * FROM $bookingDbName WHERE serieId = ?', [serieId]);
    List<Booking> serieBookingList = serieBookingMap
        .map(
          (booking) => Booking(
            id: booking['id'],
            serieId: booking['serieId'],
            type: BookingType.fromString(booking['type']),
            title: booking['title'],
            date: DateTime.parse(booking['date']),
            repetition: RepetitionType.fromString(booking['repetition']),
            amount: booking['amount'],
            amountType: AmountType.fromString(booking['amountType']),
            currency: booking['currency'],
            fromAccount: booking['fromAccount'],
            toAccount: booking['toAccount'],
            categorie: booking['categorie'],
            isBooked: booking['isBooked'] == 0 ? false : true,
          ),
        )
        .toList();
    return serieBookingList;
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
  Future<List<Booking>> updateAllBookingsInSerie(Booking updatedBooking, List<Booking> serieBookings) async {
    db = await openDatabase(localDbName);
    List<Booking> updatedBookings = [];
    try {
      for (int i = 0; i < serieBookings.length; i++) {
        await db.rawUpdate(
          'UPDATE $bookingDbName SET serieId = ?, type = ?, title = ?, date = ?, repetition = ?, amount = ?, amountType = ?, currency = ?, fromAccount = ?, toAccount = ?, categorie = ?, isBooked = ? WHERE id = ?',
          [
            updatedBooking.serieId,
            updatedBooking.type.name,
            updatedBooking.title,
            DateFormat('yyyy-MM-dd')
                .format(serieBookings[i].date), // TODO schauen, ob dies immer richtig ist oder repetition beim Bearbeiten deaktivieren
            updatedBooking.repetition.name,
            updatedBooking.amount,
            updatedBooking.amountType.name,
            updatedBooking.currency,
            updatedBooking.fromAccount,
            updatedBooking.toAccount,
            updatedBooking.categorie,
            serieBookings[i].isBooked ? 1 : 0,
            serieBookings[i].id,
          ],
        );
        List<Map> updatedSerieBookingMap = await db.rawQuery('SELECT * FROM $bookingDbName WHERE id = ?', [serieBookings[i].id]);
        List<Booking> updatedSerieBooking = updatedSerieBookingMap
            .map(
              (booking) => Booking(
                id: booking['id'],
                serieId: booking['serieId'],
                type: BookingType.fromString(booking['type']),
                title: booking['title'],
                date: DateTime.parse(booking['date']),
                repetition: RepetitionType.fromString(booking['repetition']),
                amount: booking['amount'],
                amountType: booking['amountType'],
                currency: booking['currency'],
                fromAccount: booking['fromAccount'],
                toAccount: booking['toAccount'],
                categorie: booking['categorie'],
                isBooked: booking['isBooked'] == 0 ? false : true,
              ),
            )
            .toList();
        updatedBookings.add(updatedSerieBooking[0]);
      }
    } catch (e) {
      // TODO Fehler richtig behandeln
      print('Error: $e');
    }
    return updatedBookings;
  }

  @override
  Future<List<Booking>> updateOnlyFutureBookingsInSerie(Booking updatedBooking, List<Booking> serieBookings) async {
    db = await openDatabase(localDbName);
    List<Booking> updatedBookings = [];
    try {
      for (int i = 0; i < serieBookings.length; i++) {
        if (updatedBooking.date.isBefore(serieBookings[i].date)) {
          await db.rawUpdate(
            'UPDATE $bookingDbName SET serieId = ?, type = ?, title = ?, date = ?, repetition = ?, amount = ?, amountType = ?, currency = ?, fromAccount = ?, toAccount = ?, categorie = ?, isBooked = ? WHERE id = ?',
            [
              updatedBooking.serieId,
              updatedBooking.type.name,
              updatedBooking.title,
              DateFormat('yyyy-MM-dd')
                  .format(serieBookings[i].date), // TODO schauen, ob dies immer richtig ist oder repetition beim Bearbeiten deaktivieren
              updatedBooking.repetition.name,
              updatedBooking.amount,
              updatedBooking.amountType.name,
              updatedBooking.currency,
              updatedBooking.fromAccount,
              updatedBooking.toAccount,
              updatedBooking.categorie,
              serieBookings[i].isBooked ? 1 : 0,
              serieBookings[i].id,
            ],
          );
          List<Map> updatedSerieBookingMap = await db.rawQuery('SELECT * FROM $bookingDbName WHERE id = ?', [serieBookings[i].id]);
          List<Booking> updatedSerieBooking = updatedSerieBookingMap
              .map(
                (booking) => Booking(
                  id: booking['id'],
                  serieId: booking['serieId'],
                  type: BookingType.fromString(booking['type']),
                  title: booking['title'],
                  date: DateTime.parse(booking['date']),
                  repetition: RepetitionType.fromString(booking['repetition']),
                  amount: booking['amount'],
                  amountType: booking['amountType'],
                  currency: booking['currency'],
                  fromAccount: booking['fromAccount'],
                  toAccount: booking['toAccount'],
                  categorie: booking['categorie'],
                  isBooked: booking['isBooked'] == 0 ? false : true,
                ),
              )
              .toList();
          updatedBookings.add(updatedSerieBooking[0]);
        }
      }
    } catch (e) {
      // TODO Fehler richtig behandeln
      print('Error: $e');
    }
    return updatedBookings;
  }

  @override
  Future<void> checkForNewBookings() async {
    db = await openDatabase(localDbName);
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    await db.rawUpdate('UPDATE $bookingDbName SET isBooked = ? WHERE date <= ?', [1/*= true*/, today.toIso8601String()]);
  }

  @override
  Future<int> getNewSerieId() async {
    List<Map<String, dynamic>> result = await db.rawQuery('SELECT MAX(serieId) as newSerieId FROM $bookingDbName');
    int newSerieId = result.first['newSerieId'] != null ? result.first['newSerieId'] as int : 0;
    return newSerieId + 1;
  }
}
