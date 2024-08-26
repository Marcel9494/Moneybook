import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moneybook/shared/domain/value_objects/serie_mode_type.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/budget.dart';
import '../repositories/budget_repository.dart';

class Edit implements UseCase<void, Params> {
  final BudgetRepository budgetRepository;

  Edit(this.budgetRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await budgetRepository.edit(params.budget, params.serieMode);
  }
}

class Params extends Equatable {
  final Budget budget;
  final SerieModeType serieMode;

  const Params({required this.budget, required this.serieMode});

  @override
  List<Object> get props => [budget, serieMode];
}
