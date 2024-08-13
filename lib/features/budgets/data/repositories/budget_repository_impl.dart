import 'package:dartz/dartz.dart';
import 'package:moneybook/core/error/failures.dart';
import 'package:moneybook/features/budgets/domain/entities/budget.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/budget_repository.dart';
import '../datasources/budget_local_data_source.dart';
import '../datasources/budget_remote_data_source.dart';
import '../models/budget_model.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetRemoteDataSource budgetRemoteDataSource;
  final BudgetLocalDataSource budgetLocalDataSource;

  BudgetRepositoryImpl({
    required this.budgetRemoteDataSource,
    required this.budgetLocalDataSource,
  });

  @override
  Future<Either<Failure, void>> create(Budget budget) async {
    try {
      return Right(await budgetLocalDataSource.create(budget));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> delete(Budget budget) async {
    try {
      return Right(await budgetLocalDataSource.delete(budget));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> edit(Budget budget) async {
    try {
      return Right(await budgetLocalDataSource.edit(budget));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Budget>> load(Budget budget) async {
    try {
      return Right(await budgetLocalDataSource.load(budget));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<BudgetModel>>> loadMonthly(DateTime selectedDate) async {
    try {
      return Right(await budgetLocalDataSource.loadMonthly(selectedDate));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
