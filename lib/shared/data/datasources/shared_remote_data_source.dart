abstract class SharedRemoteDataSource {
  Future<void> createDb();
}

class SharedRemoteDataSourceImpl implements SharedRemoteDataSource {
  SharedRemoteDataSourceImpl();

  @override
  Future<void> createDb() async {
    throw UnimplementedError();
  }
}
