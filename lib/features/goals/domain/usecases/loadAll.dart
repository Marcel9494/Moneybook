import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/goal.dart';
import '../repositories/goal_repository.dart';

class LoadAll implements UseCase<List<Goal>, void> {
  final GoalRepository goalRepository;

  LoadAll(this.goalRepository);

  @override
  Future<Either<Failure, List<Goal>>> call([void params]) async {
    return await goalRepository.loadAll();
  }
}
