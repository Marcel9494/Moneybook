import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:moneybook/core/consts/database_consts.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../categories/domain/value_objects/categorie_type.dart';
import '../../domain/entities/booking.dart';
import '../../domain/value_objects/amount_type.dart';
import '../../domain/value_objects/booking_type.dart';
import '../../domain/value_objects/repetition_type.dart';

abstract class BookingLocalDataSource {
  Future<void> create(Booking booking);
  Future<void> update(Booking booking);
  Future<void> delete(int id);
  Future<void> deleteAllBookingsInSerie(int serieId);
  Future<void> deleteOnlyFutureBookingsInSerie(int serieId, DateTime from);
  Future<Booking> load(int id);
  Future<List<Booking>> loadSortedMonthly(DateTime selectedDate);
  Future<List<Booking>> loadMonthlyAmountTypeBookings(DateTime selectedDate, AmountType amountType);
  Future<List<Booking>> loadCategorieBookings(String categorie);
  Future<List<Booking>> loadPastMonthlyCategorieBookings(String categorie, BookingType bookingType, DateTime date, int monthNumber);
  Future<List<Booking>> loadSerieBookings(int serieId);
  Future<void> updateAllBookingsWithCategorie(String oldCategorie, String newCategorie, CategorieType categorieType);
  Future<void> updateAllBookingsWithAccount(String oldAccount, String newAccount);
  Future<List<Booking>> updateAllBookingsInSerie(Booking updatedBooking, List<Booking> serieBookings);
  Future<List<Booking>> updateOnlyFutureBookingsInSerie(Booking updatedBooking, List<Booking> serieBookings);
  Future<void> calculateAndUpdateNewBookings();
  Future<int> getNewSerieId();
  Future<void> translate(BuildContext context);
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
      throw Exception('Booking with title ${booking.title} (id: ${booking.id}) could not updated');
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
  Future<Booking> load(int id) async {
    db = await openDatabase(localDbName);
    List<Map> loadedBookingMap = await db.rawQuery('SELECT * FROM $bookingDbName WHERE id = ?', [id]);
    List<Booking> loadedBooking = [];
    if (loadedBookingMap.isNotEmpty) {
      loadedBooking = loadedBookingMap
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
    } else {
      throw Exception('Booking with id $id not found');
    }
    return loadedBooking[0];
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

  Future<List<Booking>> loadPastMonthlyCategorieBookings(String categorie, BookingType bookingType, DateTime date, int monthNumber) async {
    db = await openDatabase(localDbName);
    int lastday = DateTime(date.year, date.month + 1, 0).day;
    String startDate = dateFormatterYYYYMMDD.format(DateTime(date.year, date.month - (monthNumber - 1), 1));
    String endDate = dateFormatterYYYYMMDD.format(DateTime(date.year, date.month, lastday));
    List<Map> categorieBookingMap = await db.rawQuery(
        'SELECT * FROM $bookingDbName WHERE categorie = ? AND type = ? AND date BETWEEN ? AND ?', [categorie, bookingType.name, startDate, endDate]);
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
    categorieBookingList.sort((first, second) => second.date.compareTo(first.date));
    return categorieBookingList;
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
    BookingType bookingType = BookingType.none;
    switch (categorieType) {
      case CategorieType.expense:
        bookingType = BookingType.expense;
      case CategorieType.income:
        bookingType = BookingType.income;
      case CategorieType.investment:
        bookingType = BookingType.investment;
    }
    await db
        .rawUpdate('UPDATE $bookingDbName SET categorie = ? WHERE categorie = ? AND type = ?', [newCategorie, oldCategorie, bookingType.name.trim()]);
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
            DateFormat('yyyy-MM-dd').format(serieBookings[i].date),
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
                amountType: AmountType.fromString(booking['amountType']),
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
      throw Exception(
          'Booking serie with title ${updatedBooking.title} (id: ${updatedBooking.id}, serieId: ${updatedBooking.serieId}) could not updated (updateAllBookingsInSerie)');
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
              DateFormat('yyyy-MM-dd').format(serieBookings[i].date),
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
                  amountType: AmountType.fromString(booking['amountType']),
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
      throw Exception(
          'Booking serie with title ${updatedBooking.title} (id: ${updatedBooking.id}, serieId: ${updatedBooking.serieId}) could not updated (updateOnlyFutureBookingsInSerie)');
    }
    return updatedBookings;
  }

  @override
  Future<void> calculateAndUpdateNewBookings() async {
    db = await openDatabase(localDbName);
    final DateTime today = DateTime.now();
    final String todayOnlyDate = "${today.year.toString().padLeft(4, '0')}-"
        "${today.month.toString().padLeft(2, '0')}-"
        "${today.day.toString().padLeft(2, '0')}";
    List<Map> newBookingMap =
        await db.rawQuery('SELECT * FROM $bookingDbName WHERE isBooked = ? AND substr(date, 1, 10) <= ?', [0/*= false*/, todayOnlyDate]);
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
            amountType: AmountType.fromString(booking['amountType']),
            currency: booking['currency'],
            fromAccount: booking['fromAccount'],
            toAccount: booking['toAccount'],
            categorie: booking['categorie'],
            isBooked: booking['isBooked'] == 0 ? false : true,
          ),
        )
        .toList();
    for (int i = 0; i < newBookingList.length; i++) {
      if (newBookingList[i].type == BookingType.expense) {
        await db.transaction((ta) async {
          List<Map> accountBalance = await ta.rawQuery('SELECT amount FROM $accountDbName WHERE name = ?', [newBookingList[i].fromAccount]);
          if (accountBalance.isNotEmpty) {
            final currentAmount = accountBalance[0]['amount'];
            final newAmount = currentAmount - newBookingList[i].amount;
            await ta.rawUpdate(
              'UPDATE $accountDbName SET amount = ? WHERE name = ?',
              [newAmount, newBookingList[i].fromAccount],
            );
            await ta.rawUpdate(
              'UPDATE $bookingDbName SET isBooked = ? WHERE id = ?',
              [1/*= true*/, newBookingList[i].id],
            );
          }
        });
      } else if (newBookingList[i].type == BookingType.income) {
        await db.transaction((ta) async {
          List<Map> accountBalance = await ta.rawQuery('SELECT amount FROM $accountDbName WHERE name = ?', [newBookingList[i].fromAccount]);
          if (accountBalance.isNotEmpty) {
            final currentAmount = accountBalance[0]['amount'];
            final newAmount = currentAmount + newBookingList[i].amount;
            await ta.rawUpdate(
              'UPDATE $accountDbName SET amount = ? WHERE name = ?',
              [newAmount, newBookingList[i].fromAccount],
            );
            await ta.rawUpdate(
              'UPDATE $bookingDbName SET isBooked = ? WHERE id = ?',
              [1/*= true*/, newBookingList[i].id],
            );
          }
        });
      } else if (newBookingList[i].type == BookingType.transfer || newBookingList[i].type == BookingType.investment) {
        await db.transaction((ta) async {
          List<Map> fromAccountBalance = await ta.rawQuery('SELECT amount FROM $accountDbName WHERE name = ?', [newBookingList[i].fromAccount]);
          List<Map> toAccountBalance = await ta.rawQuery('SELECT amount FROM $accountDbName WHERE name = ?', [newBookingList[i].toAccount]);
          if (fromAccountBalance.isNotEmpty && toAccountBalance.isNotEmpty) {
            final fromCurrentAmount = fromAccountBalance[0]['amount'];
            final toCurrentAmount = toAccountBalance[0]['amount'];

            final newFromAmount = fromCurrentAmount - newBookingList[i].amount;
            final newToAmount = toCurrentAmount + newBookingList[i].amount;

            await ta.rawUpdate(
              'UPDATE $accountDbName SET amount = ? WHERE name = ?',
              [newFromAmount, newBookingList[i].fromAccount],
            );
            await ta.rawUpdate(
              'UPDATE $accountDbName SET amount = ? WHERE name = ?',
              [newToAmount, newBookingList[i].toAccount],
            );
            await ta.rawUpdate(
              'UPDATE $bookingDbName SET isBooked = ? WHERE id = ?',
              [1/*= true*/, newBookingList[i].id],
            );
          }
        });
      }
    }
  }

  @override
  Future<int> getNewSerieId() async {
    List<Map<String, dynamic>> result = await db.rawQuery('SELECT MAX(serieId) as newSerieId FROM $bookingDbName');
    int newSerieId = result.first['newSerieId'] != null ? result.first['newSerieId'] as int : 0;
    return newSerieId + 1;
  }

  @override
  Future<void> translate(BuildContext context) async {
    db = await openDatabase(localDbName);
    List<Map> bookingMap = await db.rawQuery('SELECT * FROM $bookingDbName');
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
    for (int i = 0; i < bookingList.length; i++) {
      try {
        await db.rawUpdate(
          'UPDATE $bookingDbName SET id = ?, serieId = ?, type = ?, title = ?, date = ?, repetition = ?, amount = ?, amountType = ?, currency = ?, fromAccount = ?, toAccount = ?, categorie = ?, isBooked = ? WHERE id = ?',
          [
            bookingList[i].id,
            bookingList[i].serieId,
            bookingList[i].type.name,
            bookingList[i].title,
            DateFormat('yyyy-MM-dd').format(bookingList[i].date),
            bookingList[i].repetition.name,
            bookingList[i].amount,
            bookingList[i].amountType.name,
            bookingList[i].currency,
            bookingList[i].fromAccount,
            bookingList[i].toAccount,
            bookingList[i].categorie,
            bookingList[i].isBooked ? 1 : 0,
            bookingList[i].id,
          ],
        );
      } catch (e) {
        throw Exception('Booking with title ${bookingList[i].title} (id: ${bookingList[i].id}) could not translated');
      }
    }
  }
}
