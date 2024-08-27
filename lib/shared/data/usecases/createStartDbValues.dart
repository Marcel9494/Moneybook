import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/repositories/shared_repository.dart';

class CreateStartDbValues implements VoidUseCase<void, void> {
  final SharedRepository sharedRepository;

  CreateStartDbValues(this.sharedRepository);

  @override
  Future<Either<Failure, void>> call([void params]) async {
    return await sharedRepository.createStartDbValues();
  }
}
