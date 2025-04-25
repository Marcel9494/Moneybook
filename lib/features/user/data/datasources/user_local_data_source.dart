import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import '../../../../core/consts/database_consts.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/domain/value_objects/account_type.dart';
import '../../../bookings/domain/entities/booking.dart';
import '../../../bookings/domain/value_objects/amount_type.dart';
import '../../../bookings/domain/value_objects/booking_type.dart';
import '../../../bookings/domain/value_objects/repetition_type.dart';
import '../../../budgets/domain/entities/budget.dart';
import '../../domain/entities/user.dart';

abstract class UserLocalDataSource {
  Future<void> create(User user);
  Future<bool> checkFirstStart();
  Future<void> updateLanguage(String newLanguageCode);
  Future<void> updateCurrency(String newCurrency, bool convertBudgetAmounts);
  Future<String> getLanguage();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  UserLocalDataSourceImpl();

  @override
  Future<void> create(User user) async {
    db = await openDatabase(localDbName);
    await db.rawInsert('INSERT INTO $userDbName(id, firstStart, lastStart, language, currency, localDb) VALUES(?, ?, ?, ?, ?, ?)', [
      user.id,
      user.firstStart,
      dateFormatterYYYYMMDD.format(user.lastStart),
      user.language,
      user.currency,
      user.localDb,
    ]);
  }

  @override
  Future<bool> checkFirstStart() async {
    db = await openDatabase(localDbName);
    // TODO Code refactorn, damit Code einfacher zu verstehen ist und shared feature aufräumen (Dead Code entfernen)
    int? userCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $userDbName'));
    if (userCount == 0) {
      return true;
    }
    List<Map> userMap = await db.rawQuery('SELECT * FROM $userDbName');
    List<User> userList = userMap
        .map(
          (user) => User(
            id: user['id'],
            firstStart: user['firstStart'] == 0 ? false : true,
            lastStart: DateTime.parse(user['lastStart']),
            language: user['language'],
            currency: user['currency'] == null ? '€' : user['currency'],
            localDb: user['localDb'] == 0 ? false : true,
          ),
        )
        .toList();
    return userList[0].firstStart;
  }

  @override
  Future<void> updateLanguage(String newLanguageCode) async {
    db = await openDatabase(localDbName);
    try {
      await db.rawUpdate('UPDATE $userDbName SET language = ?', [newLanguageCode]);
    } catch (e) {
      throw Exception('Users language could not be updated to ${newLanguageCode}');
    }
  }

  @override
  Future<void> updateCurrency(String newCurrency, bool convertBudgetAmounts) async {
    double? _exchangeRate = 1.0;
    String fromCurrency = '';
    String toCurrency = '';
    db = await openDatabase(localDbName);
    if (newCurrency == '\$') {
      fromCurrency = 'EUR';
      toCurrency = 'USD';
    } else if (newCurrency == '€') {
      fromCurrency = 'USD';
      toCurrency = 'EUR';
    }
    final response = await http.get(Uri.parse('https://api.frankfurter.app/latest?base=$fromCurrency'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _exchangeRate = data['rates'][toCurrency];
    } else {
      throw Exception('Fehler beim Abrufen der Wechselkurse.');
    }
    try {
      await db.rawUpdate('UPDATE $userDbName SET currency = ?', [newCurrency]);
      // Buchungen laden und umrechnen in neue Währung mit aktuellem Wechselkurs
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
        await db.rawUpdate('UPDATE $bookingDbName SET amount = ? WHERE id = ?', [bookingList[i].amount * _exchangeRate!, bookingList[i].id]);
      }
      // Kontostände laden und umrechnen in neue Währung mit aktuellem Wechselkurs
      List<Map> accountMap = await db.rawQuery('SELECT * FROM $accountDbName');
      List<Account> accountList = accountMap
          .map(
            (account) => Account(
              id: account['id'],
              type: AccountType.fromString(account['type']),
              name: account['name'],
              amount: account['amount'],
              currency: account['currency'],
            ),
          )
          .toList();
      for (int i = 0; i < accountList.length; i++) {
        await db.rawUpdate('UPDATE $accountDbName SET amount = ? WHERE id = ?', [accountList[i].amount * _exchangeRate!, accountList[i].id]);
      }
      if (convertBudgetAmounts) {
        List<Map> budgetMap = await db.rawQuery('SELECT * FROM $budgetDbName');
        List<Budget> budgetList = budgetMap
            .map(
              (budget) => Budget(
                id: budget['id'],
                categorie: budget['categorie'],
                amount: budget['amount'],
                date: DateTime.parse(budget['date']),
                currency: budget['currency'],
                used: budget['used'],
                remaining: budget['remaining'],
                percentage: budget['percentage'],
              ),
            )
            .toList();
        for (int i = 0; i < budgetList.length; i++) {
          await db.rawUpdate('UPDATE $budgetDbName SET amount = ? WHERE id = ?', [budgetList[i].amount * _exchangeRate!, budgetList[i].id]);
        }
      }
    } catch (e) {
      throw Exception('Users currency could not be updated to ${newCurrency}');
    }
  }

  @override
  Future<String> getLanguage() async {
    db = await openDatabase(localDbName);
    try {
      List<Map<String, dynamic>> language = await db.rawQuery('SELECT language FROM $userDbName');
      if (language.isNotEmpty && language.first['language'] != null) {
        return language.first['language'];
      } else {
        throw Exception('No language found in database.');
      }
    } catch (e) {
      throw Exception('Users language could not be loaded.');
    }
  }
}
