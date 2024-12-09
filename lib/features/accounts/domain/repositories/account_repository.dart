import 'package:dartz/dartz.dart';
import 'package:moneybook/core/error/failures.dart';

import '../../../bookings/domain/entities/booking.dart';
import '../entities/account.dart';

abstract class AccountRepository {
  Future<Either<Failure, void>> create(Account account);
  Future<Either<Failure, void>> edit(Account account);
  Future<Either<Failure, void>> delete(int id);
  Future<Either<Failure, Account>> load(int id);
  Future<Either<Failure, List<Account>>> loadAll();
  Future<Either<Failure, List<Account>>> loadAccountsWithFilter(List<String> accountNameFilter);
  Future<Either<Failure, void>> deposit(Booking booking);
  Future<Either<Failure, void>> withdraw(Booking booking);
  Future<Either<Failure, void>> transfer(Booking booking);
  Future<Either<Failure, void>> transferBack(Booking booking);
  Future<Either<Failure, bool>> checkAccountName(String accountName);
}
