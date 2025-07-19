import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/goal.dart';

abstract class GoalRepository {
  Future<Either<Failure, void>> create(Goal goal);
  Future<Either<Failure, void>> update(Goal goal);
  Future<Either<Failure, void>> delete(int id);
  Future<Either<Failure, Goal>> load(int id);
  Future<Either<Failure, List<Goal>>> loadAll();
}
