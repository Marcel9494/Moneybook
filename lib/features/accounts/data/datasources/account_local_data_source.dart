import 'package:sqflite/sqflite.dart';

import '../../domain/entities/account.dart';
import '../models/account_model.dart';

abstract class AccountLocalDataSource {
  Future<void> create(Account account);
  Future<void> update(Account account);
  Future<void> delete(int id);
  Future<AccountModel> load(int id);
  Future<List<Account>> loadSortedMonthly(DateTime selectedDate);
}

class AccountLocalDataSourceImpl implements AccountLocalDataSource {
  AccountLocalDataSourceImpl();

  static const String accountDbName = 'accounts';
  var db;

  Future<void> openAccountDatabase() async {
    db = await openDatabase('$accountDbName.db', version: 1, onCreate: (Database db, int version) async {
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
  }

  @override
  Future<void> create(Account account) async {
    await openAccountDatabase();
    await db.rawInsert('INSERT INTO $accountDbName(type, name, amount, currency) VALUES(?, ?, ?, ?)', [
      account.type.name,
      account.name,
      account.amount,
      account.currency,
    ]);
  }

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<AccountModel> load(int id) {
    // TODO: implement load
    throw UnimplementedError();
  }

  @override
  Future<List<Account>> loadSortedMonthly(DateTime selectedDate) {
    // TODO: implement loadSortedMonthly
    throw UnimplementedError();
  }

  @override
  Future<void> update(Account account) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
