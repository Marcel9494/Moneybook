import 'package:sqflite/sqflite.dart';

import '../../../core/consts/database_consts.dart';
import '../../../features/accounts/domain/value_objects/account_type.dart';
import '../../../features/bookings/domain/value_objects/booking_type.dart';

abstract class SharedLocalDataSource {
  Future<void> createDb();
  Future<void> createStartDbValues();
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
            categorie TEXT NOT NULL,
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

  @override
  Future<void> createStartDbValues() async {
    db = await openDatabase(localDbName);
    int? categorieCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $categorieDbName'));
    int? accountCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $accountDbName'));
    if (categorieCount != 0 && accountCount != 0) {
      return;
    }
    /***************************************
     Start Ausgabe Kategorien erstellen
     ***************************************/
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.expense.name,
      'Lebensmittel',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.expense.name,
      'Haushaltswaren',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.expense.name,
      'Wohnen / Miete',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.expense.name,
      'Nebenkosten',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.expense.name,
      'Bildung',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.expense.name,
      'Kleidung / Mode',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.expense.name,
      'Sport / Fitness',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.expense.name,
      'Freizeit',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.expense.name,
      'Restaurant',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.expense.name,
      'Mobilität',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.expense.name,
      'Abo / Vertrag',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.expense.name,
      'Möbel',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.expense.name,
      'Technik',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.expense.name,
      'Schönheitspflege',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.expense.name,
      'Urlaub',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.expense.name,
      'Kredit',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.expense.name,
      'Sonstiges',
    ]);
    /***************************************
     Start Einnahme Kategorien erstellen
     ***************************************/
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.income.name,
      'Gehalt',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.income.name,
      'Bonuszahlung',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.income.name,
      'Zinsen',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.income.name,
      'Dividenden',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.income.name,
      'Aktiengewinne',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.income.name,
      'Mieteinnahmen',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.income.name,
      'Geldgeschenk',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.income.name,
      'P2P Kredite',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.income.name,
      'Sonstiges',
    ]);
    /***************************************
     Start Investment Kategorien erstellen
     ***************************************/
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.investment.name,
      'ETFs',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.investment.name,
      'Aktien',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.investment.name,
      'Rohstoffe / Edelmetalle',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.investment.name,
      'Kryptowährungen',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.investment.name,
      'P2P Kredite',
    ]);
    await db.rawInsert('INSERT INTO $categorieDbName(type, name) VALUES(?, ?)', [
      BookingType.investment.name,
      'Sonstiges',
    ]);
    /***************************************
     Start Konten erstellen
     ***************************************/
    await db.rawInsert('INSERT INTO $accountDbName(type, name, amount, currency) VALUES(?, ?, ?, ?)', [
      AccountType.cash.name,
      'Geldbeutel',
      0.0,
      '€',
    ]);
    await db.rawInsert('INSERT INTO $accountDbName(type, name, amount, currency) VALUES(?, ?, ?, ?)', [
      AccountType.account.name,
      'Girokonto',
      0.0,
      '€',
    ]);
    await db.rawInsert('INSERT INTO $accountDbName(type, name, amount, currency) VALUES(?, ?, ?, ?)', [
      AccountType.account.name,
      'Sparbuch',
      0.0,
      '€',
    ]);
    await db.rawInsert('INSERT INTO $accountDbName(type, name, amount, currency) VALUES(?, ?, ?, ?)', [
      AccountType.card.name,
      'Kreditkarte',
      0.0,
      '€',
    ]);
    await db.rawInsert('INSERT INTO $accountDbName(type, name, amount, currency) VALUES(?, ?, ?, ?)', [
      AccountType.capitalInvestment.name,
      'Aktiendepot',
      0.0,
      '€',
    ]);
  }
}
