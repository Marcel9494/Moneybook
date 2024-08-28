import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class FirstStart implements VoidUseCase<void, void> {
  final UserRepository userRepository;

  FirstStart(this.userRepository);

  @override
  Future<Either<Failure, bool>> call([void params]) async {
    return await userRepository.checkFirstStart();
  }
}
