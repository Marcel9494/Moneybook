import 'package:sqflite/sqflite.dart';

import '../../../core/consts/database_consts.dart';

abstract class SharedLocalDataSource {
  Future<void> createDb();
}

class SharedLocalDataSourceImpl implements SharedLocalDataSource {
  SharedLocalDataSourceImpl();

  var db;

  @override
  Future<void> createDb() async {
    db = await openDatabase(localDbName, version: localDbVersion, onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE IF NOT EXISTS $bookingDbName (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            type TEXT NOT NULL,
            title TEXT NOT NULL,
            date TEXT NOT NULL,
            repetition TEXT NOT NULL,
            amount DOUBLE NOT NULL,
            currency TEXT NOT NULL,
            fromAccount TEXT NOT NULL,
            toAccount TEXT NOT NULL,
            categorie TEXT NOT NULL
          )
          ''');
      await db.execute('''
          CREATE TABLE IF NOT EXISTS $accountDbName (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            type TEXT NOT NULL,
            name TEXT NOT NULL,
            amount DOUBLE NOT NULL,
            currency TEXT NOT NULL
          )
          ''');
      await db.execute('''
          CREATE TABLE IF NOT EXISTS $categorieDbName (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            type TEXT NOT NULL,
            name TEXT NOT NULL
          )
          ''');
      await db.execute('''
          CREATE TABLE IF NOT EXISTS $budgetDbName (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            categorieId INTEGER NOT NULL,
            date TEXT NOT NULL,
            amount DOUBLE NOT NULL,
            used DOUBLE NOT NULL,
            remaining DOUBLE NOT NULL,
            percentage DOUBLE NOT NULL,
            currency TEXT NOT NULL
          )
          ''');
    });
    return db;
  }
}
