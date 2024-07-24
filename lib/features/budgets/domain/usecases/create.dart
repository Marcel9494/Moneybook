import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/budget.dart';
import '../repositories/budget_repository.dart';

class Create implements UseCase<void, Params> {
  final BudgetRepository budgetRepository;

  Create(this.budgetRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await budgetRepository.create(params.budget);
  }
}

class Params extends Equatable {
  final Budget budget;

  const Params({required this.budget});

  @override
  List<Object> get props => [budget];
}
