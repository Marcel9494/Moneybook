import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/account_repository.dart';

class LoadAllAccounts implements UseCase<void, void> {
  final AccountRepository accountRepository;

  LoadAllAccounts(this.accountRepository);

  @override
  Future<Either<Failure, void>> call([void params]) async {
    return await accountRepository.loadAll();
  }
}
