import 'package:moneybook/core/utils/date_formatter.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/consts/database_consts.dart';
import '../../domain/entities/goal.dart';
import '../../domain/value_objects/goal_type.dart';

abstract class GoalLocalDataSource {
  Future<void> create(Goal goal);
  Future<void> update(Goal goal);
  Future<void> delete(int id);
  Future<Goal> load(int id);
  Future<List<Goal>> loadAll();
}

class GoalLocalDataSourceImpl implements GoalLocalDataSource {
  GoalLocalDataSourceImpl();

  @override
  Future<void> create(Goal goal) async {
    db = await openDatabase(localDbName);
    await db.rawInsert(
      'INSERT INTO $goalDbName(name, amount, goalAmount, currency, startDate, endDate, type) VALUES(?, ?, ?, ?, ?, ?, ?)',
      [
        goal.name,
        goal.amount,
        goal.goalAmount,
        goal.currency,
        dateFormatterYYYYMMDD.format(goal.startDate),
        dateFormatterYYYYMMDD.format(goal.endDate),
        goal.type.name,
      ],
    );
  }

  @override
  Future<void> update(Goal goal) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Goal> load(int id) {
    // TODO: implement load
    throw UnimplementedError();
  }

  @override
  Future<List<Goal>> loadAll() async {
    db = await openDatabase(localDbName);
    List<Map> goalMap = await db.rawQuery('SELECT * FROM $goalDbName');
    List<Goal> goalList = goalMap
        .map(
          (goal) => Goal(
            id: goal['id'],
            name: goal['name'],
            type: GoalType.fromString(goal['type']),
            startDate: DateTime.parse(goal['startDate']),
            endDate: DateTime.parse(goal['endDate']),
            amount: goal['amount'],
            goalAmount: goal['goalAmount'],
            currency: goal['currency'],
          ),
        )
        .toList();
    return goalList;
  }
}
