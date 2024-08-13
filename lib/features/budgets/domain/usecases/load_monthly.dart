import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../categories/domain/repositories/categorie_repository.dart';
import '../repositories/budget_repository.dart';

class LoadMonthly implements UseCase<void, DateTime> {
  final BudgetRepository budgetRepository;
  final CategorieRepository categorieRepository;

  LoadMonthly(this.budgetRepository, this.categorieRepository);

  @override
  Future<Either<Failure, void>> call(DateTime selectedDate) async {
    return await budgetRepository.loadMonthly(selectedDate);
  }
}
