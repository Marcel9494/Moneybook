import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/categorie.dart';
import '../repositories/categorie_repository.dart';

class Create implements UseCase<void, Params> {
  final CategorieRepository categorieRepository;

  Create(this.categorieRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await categorieRepository.create(params.categorie);
  }
}

class Params extends Equatable {
  final Categorie categorie;

  const Params({required this.categorie});

  @override
  List<Object> get props => [categorie];
}
