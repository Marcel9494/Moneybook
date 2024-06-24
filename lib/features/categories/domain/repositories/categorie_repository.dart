import 'package:dartz/dartz.dart';
import 'package:moneybook/core/error/failures.dart';

import '../entities/categorie.dart';

abstract class CategorieRepository {
  Future<Either<Failure, void>> create(Categorie categorie);
  Future<Either<Failure, void>> edit(Categorie categorie);
  Future<Either<Failure, void>> delete(int id);
  Future<Either<Failure, Categorie>> load(int id);
  Future<Either<Failure, List<Categorie>>> loadAll();
}
