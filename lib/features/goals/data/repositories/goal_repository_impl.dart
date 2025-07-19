import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/goal.dart';
import '../../domain/repositories/goal_repository.dart';
import '../datasources/goal_local_data_source.dart';

class GoalRepositoryImpl implements GoalRepository {
  final GoalLocalDataSource goalLocalDataSource;

  GoalRepositoryImpl({
    required this.goalLocalDataSource,
  });

  @override
  Future<Either<Failure, void>> create(Goal goal) async {
    try {
      return Right(await goalLocalDataSource.create(goal));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> update(Goal goal) async {
    try {
      return Right(await goalLocalDataSource.update(goal));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> delete(int id) async {
    try {
      return Right(await goalLocalDataSource.delete(id));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Goal>> load(int id) async {
    try {
      return Right(await goalLocalDataSource.load(id));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Goal>>> loadAll() async {
    try {
      return Right(await goalLocalDataSource.loadAll());
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
