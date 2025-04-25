import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class UpdateLanguageUseCase implements UseCase<void, Params> {
  final UserRepository userRepository;

  UpdateLanguageUseCase(this.userRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await userRepository.updateLanguage(params.newLanguageCode);
  }
}

class Params extends Equatable {
  final String newLanguageCode;

  const Params({required this.newLanguageCode});

  @override
  List<Object> get props => [newLanguageCode];
}
