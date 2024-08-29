abstract class UserRemoteDataSource {
  Future<void> create();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  UserRemoteDataSourceImpl();

  @override
  Future<void> create() async {
    throw UnimplementedError();
  }
}
