import 'package:dartz/dartz.dart';
import 'package:moneybook/core/error/failures.dart';
import 'package:moneybook/features/accounts/domain/entities/account.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/account_local_data_source.dart';
import '../datasources/account_remote_data_source.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource accountRemoteDataSource;
  final AccountLocalDataSource accountLocalDataSource;

  AccountRepositoryImpl({
    required this.accountRemoteDataSource,
    required this.accountLocalDataSource,
  });

  @override
  Future<Either<Failure, void>> create(Account account) async {
    try {
      return Right(await accountLocalDataSource.create(account));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Account>> load(int id) {
    // TODO: implement load
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Account>>> loadSortedMonthly(DateTime selectedDate) {
    // TODO: implement loadSortedMonthly
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> update(Account account) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
