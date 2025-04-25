import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/categorie_repository.dart';

class TranslateCategories implements UseCase<void, Params> {
  final CategorieRepository categorieRepository;

  TranslateCategories(this.categorieRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await categorieRepository.translate(params.context);
  }
}

class Params extends Equatable {
  final BuildContext context;

  const Params({required this.context});

  @override
  List<Object> get props => [context];
}
