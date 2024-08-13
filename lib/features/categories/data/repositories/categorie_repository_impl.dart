import 'package:dartz/dartz.dart';
import 'package:moneybook/core/error/failures.dart';
import 'package:moneybook/features/categories/domain/value_objects/categorie_type.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/categorie.dart';
import '../../domain/repositories/categorie_repository.dart';
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
  Future<Either<Failure, void>> delete(int id) async {
    try {
      return Right(await categorieLocalDataSource.delete(id));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Categorie>>> load(List<int> ids) async {
    try {
      return Right(await categorieLocalDataSource.load(ids));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Categorie>>> loadAll() async {
    try {
      return Right(await categorieLocalDataSource.loadAll());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> edit(Categorie categorie) async {
    try {
      return Right(await categorieLocalDataSource.edit(categorie));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Categorie>> getId(String categorieName, CategorieType categorieType) async {
    try {
      return Right(await categorieLocalDataSource.getId(categorieName, categorieType));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
