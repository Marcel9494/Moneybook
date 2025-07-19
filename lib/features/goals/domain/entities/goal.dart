import 'package:equatable/equatable.dart';
import 'package:moneybook/features/goals/domain/value_objects/goal_type.dart';

class Goal extends Equatable {
  final int id;
  final String name;
  final double amount;
  final String currency;
  final DateTime startDate;
  final DateTime endDate;
  final GoalType type;

  const Goal({
    required this.id,
    required this.name,
    required this.amount,
    required this.currency,
    required this.startDate,
    required this.endDate,
    required this.type,
  });

  @override
  List<Object?> get props => [id, name, amount, currency, startDate, endDate, type];
}
