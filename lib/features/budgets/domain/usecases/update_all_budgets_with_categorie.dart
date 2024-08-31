import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/budget_repository.dart';

class UpdateAllBudgetsWithCategorie implements UseCase<void, Params> {
  final BudgetRepository budgetRepository;

  UpdateAllBudgetsWithCategorie(this.budgetRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await budgetRepository.updateAllBudgetsWithCategorie(params.oldCategorie, params.newCategorie);
  }
}

class Params extends Equatable {
  final String oldCategorie;
  final String newCategorie;

  const Params({required this.oldCategorie, required this.newCategorie});

  @override
  List<Object> get props => [oldCategorie, newCategorie];
}
