import '../../domain/entities/budget.dart';

class BudgetModel extends Budget {
  BudgetModel({
    required super.id,
    required super.categorie,
    required super.date,
    required super.amount,
    required super.used,
    required super.remaining,
    required super.percentage,
    required super.currency,
  });
}
