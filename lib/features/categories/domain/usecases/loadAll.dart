import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/categorie_repository.dart';

class LoadAll implements VoidUseCase<void, void> {
  final CategorieRepository categorieRepository;

  LoadAll(this.categorieRepository);

  @override
  Future<Either<Failure, void>> call([void params]) async {
    return await categorieRepository.loadAll();
  }
}
