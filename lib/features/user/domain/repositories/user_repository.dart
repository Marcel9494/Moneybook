import 'package:dartz/dartz.dart';
import 'package:moneybook/core/error/failures.dart';

import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, void>> create(User user);
  Future<Either<Failure, bool>> checkFirstStart();
}