import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../categories/domain/usecases/create.dart';
import '../../domain/entities/categorie.dart';

part 'categorie_event.dart';
part 'categorie_state.dart';

const String CREATE_CATEGORIE_FAILURE = 'Kategorie konnte nicht erstellt werden.';

class CategorieBloc extends Bloc<CategorieEvent, CategorieState> {
  final Create createUseCase;

  CategorieBloc(this.createUseCase) : super(Initial()) {
    on<CategorieEvent>((event, emit) async {
      if (event is CreateCategorie) {
        final createCategorieEither = await createUseCase.categorieRepository.create(event.categorie);
        createCategorieEither.fold((failure) {
          emit(const Error(message: CREATE_CATEGORIE_FAILURE));
        }, (_) {
          emit(Finished());
        });
      }
    });
  }
}
