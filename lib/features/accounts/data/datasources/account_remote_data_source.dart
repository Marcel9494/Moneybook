import '../../domain/entities/account.dart';

abstract class AccountRemoteDataSource {
  Future<void> create(Account account);
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  AccountRemoteDataSourceImpl();

  @override
  Future<void> create(Account account) async {
    throw UnimplementedError();
  }
}
