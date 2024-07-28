import 'package:moneybook/features/categories/domain/entities/categorie.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/consts/database_consts.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../categories/domain/value_objects/categorie_type.dart';
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
  Future<List<BudgetModel>> loadMonthly(DateTime selectedDate) async {
    db = await openDatabase(localDbName);
    int lastday = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    String startDate = dateFormatterYYYYMMDD.format(DateTime(selectedDate.year, selectedDate.month, 1));
    String endDate = dateFormatterYYYYMMDD.format(DateTime(selectedDate.year, selectedDate.month, lastday));
    List<Map> budgetMap = await db.rawQuery(
        'SELECT * FROM $budgetDbName INNER JOIN $categorieDbName ON budgets.categorieId = categories.id WHERE budgets.date BETWEEN ? AND ?',
        [startDate, endDate]);
    print(budgetMap);
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
            categorie: Categorie(
              id: budget['categorieId'],
              name: budget['name'],
              type: CategorieType.fromString(budget['type']),
            ),
          ),
        )
        .toList();
    budgetList.sort((first, second) => second.percentage.compareTo(first.percentage));
    return budgetList;
  }
}
