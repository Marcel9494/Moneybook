import '../../domain/entities/goal.dart';

class GoalModel extends Goal {
  const GoalModel({
    required super.id,
    required super.name,
    required super.amount,
    required super.currency,
    required super.startDate,
    required super.endDate,
    required super.type,
  });
}
