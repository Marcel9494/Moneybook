import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class GetLanguageUseCase implements UseCase<void, void> {
  final UserRepository userRepository;

  GetLanguageUseCase(this.userRepository);

  @override
  Future<Either<Failure, void>> call([void params]) async {
    return await userRepository.getLanguage();
  }
}
