import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/goal.dart';
import '../repositories/goal_repository.dart';

class Update implements UseCase<void, Params> {
  final GoalRepository goalRepository;

  Update(this.goalRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await goalRepository.update(params.goal);
  }
}

class Params extends Equatable {
  final Goal goal;

  const Params({required this.goal});

  @override
  List<Object> get props => [goal];
}
