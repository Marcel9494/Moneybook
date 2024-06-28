import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/account_repository.dart';

class Delete implements UseCase<void, Params> {
  final AccountRepository accountRepository;

  Delete(this.accountRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await accountRepository.delete(params.accountId);
  }
}

class Params extends Equatable {
  final int accountId;

  const Params({required this.accountId});

  @override
  List<Object> get props => [accountId];
}
