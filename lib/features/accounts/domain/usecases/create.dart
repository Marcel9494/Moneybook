import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/account.dart';
import '../repositories/account_repository.dart';

class Create implements UseCase<void, Params> {
  final AccountRepository accountRepository;

  Create(this.accountRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await accountRepository.create(params.account);
  }
}

class Params extends Equatable {
  final Account account;

  const Params({required this.account});

  @override
  List<Object> get props => [account];
}
