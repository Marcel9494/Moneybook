import 'package:dartz/dartz.dart';
import 'package:moneybook/core/error/failures.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/shared_repository.dart';
import '../datasources/shared_local_data_source.dart';
import '../datasources/shared_remote_data_source.dart';

class SharedRepositoryImpl implements SharedRepository {
  final SharedRemoteDataSource sharedRemoteDataSource;
  final SharedLocalDataSource sharedLocalDataSource;

  SharedRepositoryImpl({
    required this.sharedRemoteDataSource,
    required this.sharedLocalDataSource,
  });

  @override
  Future<Either<Failure, void>> createDb() async {
    try {
      return Right(await sharedLocalDataSource.createDb());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> createStartDbValues() async {
    try {
      return Right(await sharedLocalDataSource.createStartDbValues());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> existsDb() async {
    try {
      return Right(await sharedLocalDataSource.existsDb());
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
