import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/goal_repository.dart';

class Delete implements UseCase<void, Params> {
  final GoalRepository goalRepository;

  Delete(this.goalRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await goalRepository.delete(params.id);
  }
}

class Params extends Equatable {
  final int id;

  const Params({required this.id});

  @override
  List<Object> get props => [id];
}
