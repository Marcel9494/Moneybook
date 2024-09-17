import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/account_repository.dart';

class LoadFilteredAccounts implements UseCase<void, Params> {
  final AccountRepository accountRepository;

  LoadFilteredAccounts(this.accountRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await accountRepository.loadAccountsWithFilter(params.accountNameFilter);
  }
}

class Params extends Equatable {
  final List<String> accountNameFilter;

  const Params({required this.accountNameFilter});

  @override
  List<Object> get props => [accountNameFilter];
}
