import 'package:dartz/dartz.dart';
import 'package:moneybook/core/error/failures.dart';

abstract class SharedRepository {
  Future<Either<Failure, void>> createDb();
  Future<Either<Failure, void>> createStartDbValues();
}
