import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/categorie_repository.dart';
import '../value_objects/categorie_type.dart';

class GetId implements UseCase<void, Params> {
  final CategorieRepository categorieRepository;

  GetId(this.categorieRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await categorieRepository.getId(
      params.categorieName,
      params.categorieType,
    );
  }
}

class Params extends Equatable {
  final String categorieName;
  final CategorieType categorieType;

  const Params({
    required this.categorieName,
    required this.categorieType,
  });

  @override
  List<Object> get props => [categorieName, categorieType];
}
