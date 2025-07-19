import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/goal.dart';
import '../repositories/goal_repository.dart';

class Load implements UseCase<Goal, Params> {
  final GoalRepository goalRepository;

  Load(this.goalRepository);

  @override
  Future<Either<Failure, Goal>> call(Params params) async {
    return await goalRepository.load(params.id);
  }
}

class Params extends Equatable {
  final int id;

  const Params({required this.id});

  @override
  List<Object> get props => [id];
}
