import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class Create implements UseCase<void, Params> {
  final UserRepository userRepository;

  Create(this.userRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await userRepository.create(params.user);
  }
}

class Params extends Equatable {
  final User user;

  const Params({required this.user});

  @override
  List<Object> get props => [user];
}
