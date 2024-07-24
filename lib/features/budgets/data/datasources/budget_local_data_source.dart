import 'package:sqflite/sqflite.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/budget.dart';
import '../models/budget_model.dart';

abstract class BudgetLocalDataSource {
  Future<void> create(Budget budget);
  Future<void> edit(Budget budget);
  Future<void> delete(Budget budget);
  Future<BudgetModel> load(Budget budget);
  Future<List<Budget>> loadMonthly(DateTime selectedDate);
}

class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  BudgetLocalDataSourceImpl();

  static const String budgetDbName = 'budgets';
  var db;

  Future<dynamic> openBookingDatabase(String databaseName) async {
    db = await openDatabase('$databaseName.db', version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE IF NOT EXISTS $databaseName (
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

  @override
  Future<void> create(Budget budget) async {
    db = await openBookingDatabase(budgetDbName);
    print(budget);
    await db.rawInsert(
      'INSERT INTO $budgetDbName(categorieId, date, amount, used, remaining, percentage, currency) VALUES(?, ?, ?, ?, ?, ?, ?)',
      [
        budget.categorieId,
        dateFormatterYYYYMMDD.format(budget.date),
        budget.amount,
        budget.used,
        budget.remaining,
        budget.percentage,
        budget.currency,
      ],
    );
  }

  @override
  Future<void> delete(Budget budget) async {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> edit(Budget budget) async {
    // TODO: implement edit
    throw UnimplementedError();
  }

  @override
  Future<BudgetModel> load(Budget budget) async {
    // TODO: implement load
    throw UnimplementedError();
  }

  @override
  Future<List<Budget>> loadMonthly(DateTime selectedDate) async {
    db = await openBookingDatabase(budgetDbName);
    int lastday = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    String startDate = dateFormatterYYYYMMDD.format(DateTime(selectedDate.year, selectedDate.month, 1));
    String endDate = dateFormatterYYYYMMDD.format(DateTime(selectedDate.year, selectedDate.month, lastday));
    List<Map> budgetMap = await db.rawQuery('SELECT * FROM $budgetDbName WHERE date BETWEEN ? AND ?', [startDate, endDate]);
    List<Budget> budgetList = budgetMap
        .map(
          (budget) => Budget(
            id: budget['id'],
            categorieId: budget['categorieId'],
            amount: budget['amount'],
            date: DateTime.parse(budget['date']),
            currency: budget['currency'],
            used: budget['used'],
            remaining: budget['remaining'],
            percentage: budget['percentage'],
          ),
        )
        .toList();
    budgetList.sort((first, second) => second.percentage.compareTo(first.percentage));
    return budgetList;
  }
}
