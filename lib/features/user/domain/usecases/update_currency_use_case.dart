import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class UpdateCurrencyUseCase implements UseCase<void, Params> {
  final UserRepository userRepository;

  UpdateCurrencyUseCase(this.userRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await userRepository.updateCurrency(params.newCurrency, params.convertBudgetAmounts);
  }
}

class Params extends Equatable {
  final String newCurrency;
  final bool convertBudgetAmounts;

  const Params({required this.newCurrency, required this.convertBudgetAmounts});

  @override
  List<Object> get props => [newCurrency, convertBudgetAmounts];
}
