import 'package:dartz/dartz.dart';
import 'package:moneybook/core/error/failures.dart';

import '../../../../shared/domain/value_objects/serie_mode_type.dart';
import '../../data/models/budget_model.dart';
import '../entities/budget.dart';

abstract class BudgetRepository {
  Future<Either<Failure, void>> create(Budget budget);
  Future<Either<Failure, void>> edit(Budget budget);
  Future<Either<Failure, void>> delete(Budget budget, SerieModeType serieMode);
  Future<Either<Failure, Budget>> load(Budget budget);
  Future<Either<Failure, List<BudgetModel>>> loadMonthly(DateTime selectedDate);
}
