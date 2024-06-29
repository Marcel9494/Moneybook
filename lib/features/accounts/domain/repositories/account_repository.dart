import 'package:dartz/dartz.dart';
import 'package:moneybook/core/error/failures.dart';

import '../entities/account.dart';

abstract class AccountRepository {
  Future<Either<Failure, void>> create(Account account);
  Future<Either<Failure, void>> edit(Account account);
  Future<Either<Failure, void>> delete(int id);
  Future<Either<Failure, Account>> load(int id);
  Future<Either<Failure, List<Account>>> loadAll();
}
