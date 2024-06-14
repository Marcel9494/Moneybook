import '../../domain/entities/categorie.dart';

abstract class CategorieRemoteDataSource {
  Future<void> create(Categorie categorie);
}

class CategorieRemoteDataSourceImpl implements CategorieRemoteDataSource {
  CategorieRemoteDataSourceImpl();

  @override
  Future<void> create(Categorie categorie) async {
    throw UnimplementedError();
  }
}
