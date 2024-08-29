import 'package:dartz/dartz.dart';
import 'package:moneybook/core/error/failures.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_data_source.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource userRemoteDataSource;
  final UserLocalDataSource userLocalDataSource;

  UserRepositoryImpl({
    required this.userRemoteDataSource,
    required this.userLocalDataSource,
  });

  @override
  Future<Either<Failure, void>> create(User user) async {
    try {
      return Right(await userLocalDataSource.create(user));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkFirstStart() async {
    try {
      return Right(await userLocalDataSource.checkFirstStart());
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
