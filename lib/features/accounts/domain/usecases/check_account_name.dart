import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/account_repository.dart';

class CheckAccountName implements UseCase<void, Params> {
  final AccountRepository accountRepository;

  CheckAccountName(this.accountRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await accountRepository.checkAccountName(params.accountName);
  }
}

class Params extends Equatable {
  final String accountName;

  const Params({required this.accountName});

  @override
  List<Object> get props => [accountName];
}
