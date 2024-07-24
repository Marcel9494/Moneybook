import '../../domain/entities/budget.dart';

class BudgetModel extends Budget {
  const BudgetModel({
    required super.id,
    required super.categorieId,
    required super.amount,
    required super.used,
    required super.remaining,
    required super.percentage,
    required super.currency,
  });
}
