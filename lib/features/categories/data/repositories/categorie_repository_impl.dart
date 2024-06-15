import 'package:dartz/dartz.dart';
import 'package:moneybook/core/error/failures.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/categorie.dart';
import '../../domain/repositories/categorie_repository.dart';
import '../../domain/value_objects/categorie_type.dart';
import '../datasources/categorie_local_data_source.dart';
import '../datasources/categorie_remote_data_source.dart';

class CategorieRepositoryImpl implements CategorieRepository {
  final CategorieRemoteDataSource categorieRemoteDataSource;
  final CategorieLocalDataSource categorieLocalDataSource;

  CategorieRepositoryImpl({
    required this.categorieRemoteDataSource,
    required this.categorieLocalDataSource,
  });

  @override
  Future<Either<Failure, void>> create(Categorie categorie) async {
    try {
      return Right(await categorieLocalDataSource.create(categorie));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Categorie>> load(int id) {
    // TODO: implement load
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Categorie>>> loadAll(CategorieType categorieType) {
    // TODO: implement loadSortedMonthly
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> update(Categorie categorie) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
