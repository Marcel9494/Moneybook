import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/categorie_repository.dart';
import '../value_objects/categorie_type.dart';

class LoadAll implements UseCase<void, CategorieType> {
  final CategorieRepository categorieRepository;

  LoadAll(this.categorieRepository);

  @override
  Future<Either<Failure, void>> call(CategorieType categorieType) async {
    return await categorieRepository.loadAll(categorieType);
  }
}
