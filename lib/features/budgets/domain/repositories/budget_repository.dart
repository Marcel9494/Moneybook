import 'package:dartz/dartz.dart';
import 'package:moneybook/core/error/failures.dart';

import '../entities/budget.dart';

abstract class BudgetRepository {
  Future<Either<Failure, void>> create(Budget budget);
  Future<Either<Failure, void>> edit(Budget budget);
  Future<Either<Failure, void>> delete(Budget budget);
  Future<Either<Failure, Budget>> load(Budget budget);
  Future<Either<Failure, List<Budget>>> loadMonthly(DateTime selectedDate);
}
