import 'package:sqflite/sqflite.dart';

import '../../../bookings/domain/entities/booking.dart';
import '../../domain/entities/account.dart';
import '../../domain/value_objects/account_type.dart';
import '../models/account_model.dart';

abstract class AccountLocalDataSource {
  Future<void> create(Account account);
  Future<void> edit(Account account);
  Future<void> delete(int id);
  Future<AccountModel> load(int id);
  Future<List<Account>> loadAll();
  Future<void> deposit(Booking booking);
  Future<void> withdraw(Booking booking);
  Future<void> transfer(Booking booking);
}

class AccountLocalDataSourceImpl implements AccountLocalDataSource {
  AccountLocalDataSourceImpl();

  static const String accountDbName = 'accounts';
  var db;

  Future<dynamic> openAccountDatabase(String databaseName) async {
    db ??= await openDatabase('$accountDbName.db', version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE IF NOT EXISTS $accountDbName (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            type TEXT NOT NULL,
            name TEXT NOT NULL,
            amount DOUBLE NOT NULL,
            currency TEXT NOT NULL
          )
          ''');
    });
    return db;
  }

  @override
  Future<void> create(Account account) async {
    await openAccountDatabase(accountDbName);
    await db.rawInsert('INSERT INTO $accountDbName(type, name, amount, currency) VALUES(?, ?, ?, ?)', [
      account.type.name,
      account.name,
      account.amount,
      account.currency,
    ]);
  }

  @override
  Future<void> delete(int id) async {
    db = await openAccountDatabase(accountDbName);
    await db.rawDelete('DELETE FROM $accountDbName WHERE id = ?', [id]);
  }

  @override
  Future<AccountModel> load(int id) {
    // TODO: implement load
    throw UnimplementedError();
  }

  @override
  Future<void> edit(Account account) async {
    db = await openAccountDatabase(accountDbName);
    try {
      await db.rawUpdate('UPDATE $accountDbName SET id = ?, type = ?, name = ?, amount = ?, currency = ? WHERE id = ?', [
        account.id,
        account.type.name,
        account.name,
        account.amount,
        account.currency,
        account.id,
      ]);
    } catch (e) {
      // TODO Fehler richtig behandeln
      print('Error: $e');
    }
  }

  @override
  Future<List<Account>> loadAll() async {
    db = await openAccountDatabase(accountDbName);
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
    accountList.sort((first, second) => second.type.name.compareTo(first.type.name));
    return accountList;
  }

  @override
  Future<void> deposit(Booking booking) async {
    db = await openAccountDatabase(accountDbName);
    List<Map> accountBalance = await db.rawQuery('SELECT amount FROM $accountDbName WHERE name = ?', [booking.fromAccount]);
    await db.rawUpdate('UPDATE $accountDbName SET amount = ? WHERE name = ?', [
      accountBalance[0]['amount'] + booking.amount,
      booking.fromAccount,
    ]);
  }

  @override
  Future<void> withdraw(Booking booking) async {
    db = await openAccountDatabase(accountDbName);
    List<Map> accountBalance = await db.rawQuery('SELECT amount FROM $accountDbName WHERE name = ?', [booking.fromAccount]);
    await db.rawUpdate('UPDATE $accountDbName SET amount = ? WHERE name = ?', [
      accountBalance[0]['amount'] - booking.amount,
      booking.fromAccount,
    ]);
  }

  @override
  Future<void> transfer(Booking booking) async {
    db = await openAccountDatabase(accountDbName);
    List<Map> fromAccountBalance = await db.rawQuery('SELECT amount FROM $accountDbName WHERE name = ?', [booking.fromAccount]);
    List<Map> toAccountBalance = await db.rawQuery('SELECT amount FROM $accountDbName WHERE name = ?', [booking.toAccount]);
    await db.rawUpdate('UPDATE $accountDbName SET amount = ? WHERE name = ?', [
      fromAccountBalance[0]['amount'] - booking.amount,
      booking.fromAccount,
    ]);
    await db.rawUpdate('UPDATE $accountDbName SET amount = ? WHERE name = ?', [
      toAccountBalance[0]['amount'] + booking.amount,
      booking.toAccount,
    ]);
  }
}
