import 'package:sqflite/sqflite.dart';

import '../../../../core/consts/database_consts.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/budget.dart';
import '../models/budget_model.dart';

abstract class BudgetLocalDataSource {
  Future<void> create(Budget budget);
  Future<void> edit(Budget budget);
  Future<void> delete(Budget budget);
  Future<BudgetModel> load(Budget budget);
  Future<List<BudgetModel>> loadMonthly(DateTime selectedDate);
}

class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  BudgetLocalDataSourceImpl();

  @override
  Future<void> create(Budget budget) async {
    print(budget);
    print("DB: $localDbName");
    print("Tabelle: $budgetDbName");
    db = await openDatabase(localDbName);
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
    print('Test');
    print(budgetDbName);
    db = await openDatabase(localDbName);
    await db.rawDelete('DELETE FROM $budgetDbName WHERE id = ?', [budget.id]);
  }

  @override
  Future<void> edit(Budget budget) async {
    db = await openDatabase(localDbName);
    try {
      await db.rawUpdate(
          'UPDATE $budgetDbName SET id = ?, categorieId = ?, amount = ?, currency = ?, used = ?, remaining = ?, percentage = ?, date = ? WHERE id = ?',
          [
            budget.id,
            budget.categorieId,
            budget.amount,
            budget.currency,
            budget.used,
            budget.remaining,
            budget.percentage,
            budget.date,
            budget.id,
          ]);
    } catch (e) {
      // TODO Fehler richtig behandeln
      print('Error: $e');
    }
  }

  @override
  Future<BudgetModel> load(Budget budget) async {
    // TODO: implement load
    throw UnimplementedError();
  }

  @override
  Future<List<BudgetModel>> loadMonthly(DateTime selectedDate) async {
    db = await openDatabase(localDbName);
    int lastday = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    String startDate = dateFormatterYYYYMMDD.format(DateTime(selectedDate.year, selectedDate.month, 1));
    String endDate = dateFormatterYYYYMMDD.format(DateTime(selectedDate.year, selectedDate.month, lastday));
    List<Map> budgetMap = await db.rawQuery('SELECT * FROM $budgetDbName WHERE date >= ? AND date <= ?', [startDate, endDate]);
    //List<Map> budgetMap = await db.rawQuery(
    //    'SELECT * FROM $budgetDbName INNER JOIN $categorieDbName ON budgets.categorieId = categories.id WHERE budgets.date BETWEEN ? AND ?',
    //    [startDate, endDate]);
    List<BudgetModel> budgetList = budgetMap
        .map(
          (budget) => BudgetModel(
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
