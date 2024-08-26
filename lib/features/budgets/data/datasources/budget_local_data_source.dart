import 'package:moneybook/shared/domain/value_objects/serie_mode_type.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/consts/database_consts.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/budget.dart';
import '../models/budget_model.dart';

abstract class BudgetLocalDataSource {
  Future<void> create(Budget budget);
  Future<void> edit(Budget budget, SerieModeType serieMode);
  Future<void> delete(Budget budget, SerieModeType serieMode);
  Future<BudgetModel> load(Budget budget);
  Future<List<BudgetModel>> loadMonthly(DateTime selectedDate);
}

class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  BudgetLocalDataSourceImpl();

  @override
  Future<void> create(Budget budget) async {
    db = await openDatabase(localDbName);
    await db.rawInsert(
      'INSERT INTO $budgetDbName(categorie, date, amount, used, remaining, percentage, currency) VALUES(?, ?, ?, ?, ?, ?, ?)',
      [
        budget.categorie,
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
  Future<void> delete(Budget budget, SerieModeType serieMode) async {
    db = await openDatabase(localDbName);
    if (serieMode == SerieModeType.one) {
      await db.rawDelete('DELETE FROM $budgetDbName WHERE id = ?', [budget.id]);
    } else if (serieMode == SerieModeType.onlyFuture) {
      await db
          .rawDelete('DELETE FROM $budgetDbName WHERE categorie = ? AND date >= ?', [budget.categorie, dateFormatterYYYYMMDD.format(budget.date)]);
    } else if (serieMode == SerieModeType.all) {
      await db.rawDelete('DELETE FROM $budgetDbName WHERE categorie = ?', [budget.categorie]);
    }
  }

  @override
  Future<void> edit(Budget budget, SerieModeType serieMode) async {
    db = await openDatabase(localDbName);
    try {
      if (serieMode == SerieModeType.one) {
        await db.rawUpdate(
          'UPDATE $budgetDbName SET categorie = ?, amount = ?, currency = ? WHERE id = ?',
          [
            budget.categorie,
            budget.amount,
            budget.currency,
            budget.id,
          ],
        );
      } else if (serieMode == SerieModeType.onlyFuture) {
        await db.rawUpdate(
          'UPDATE $budgetDbName SET categorie = ?, amount = ?, currency = ? WHERE categorie = ? AND date >= ?',
          [budget.categorie, budget.amount, budget.currency, budget.categorie, dateFormatterYYYYMMDD.format(budget.date)],
        );
      } else if (serieMode == SerieModeType.all) {
        await db.rawUpdate(
          'UPDATE $budgetDbName SET categorie = ?, amount = ?, currency = ? WHERE categorie = ?',
          [
            budget.categorie,
            budget.amount,
            budget.currency,
            budget.categorie,
          ],
        );
      }
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
    List<BudgetModel> budgetList = budgetMap
        .map(
          (budget) => BudgetModel(
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
    budgetList.sort((first, second) => second.percentage.compareTo(first.percentage));
    return budgetList;
  }
}
