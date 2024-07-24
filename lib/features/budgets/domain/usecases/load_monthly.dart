import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/budget_repository.dart';

class LoadMonthly implements UseCase<void, DateTime> {
  final BudgetRepository budgetRepository;

  LoadMonthly(this.budgetRepository);

  @override
  Future<Either<Failure, void>> call(DateTime selectedDate) async {
    return await budgetRepository.loadMonthly(selectedDate);
  }
}
