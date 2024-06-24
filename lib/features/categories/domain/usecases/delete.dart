import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/categorie_repository.dart';

class Delete implements UseCase<void, Params> {
  final CategorieRepository categorieRepository;

  Delete(this.categorieRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await categorieRepository.delete(params.categorieId);
  }
}

class Params extends Equatable {
  final int categorieId;

  const Params({required this.categorieId});

  @override
  List<Object> get props => [categorieId];
}
