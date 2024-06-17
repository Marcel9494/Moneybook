import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../categories/domain/usecases/create.dart';
import '../../domain/entities/categorie.dart';
import '../../domain/usecases/loadAll.dart';
import '../../domain/value_objects/categorie_type.dart';

part 'categorie_event.dart';
part 'categorie_state.dart';

const String CREATE_CATEGORIE_FAILURE = 'Kategorie konnte nicht erstellt werden.';
const String EDIT_CATEGORIE_FAILURE = 'Kategorie konnte nicht bearbeitet werden.';
const String DELETE_CATEGORIE_FAILURE = 'Kategorie konnte nicht gelöscht werden.';
const String LOAD_CATEGORIES_FAILURE = 'Kategorien konnten nicht geladen werden.';

class CategorieBloc extends Bloc<CategorieEvent, CategorieState> {
  final Create createUseCase;
  final LoadAll loadUseCase;

  CategorieBloc(this.createUseCase, this.loadUseCase) : super(Initial()) {
    on<CategorieEvent>((event, emit) async {
      if (event is CreateCategorie) {
        final createCategorieEither = await createUseCase.categorieRepository.create(event.categorie);
        createCategorieEither.fold((failure) {
          emit(const Error(message: CREATE_CATEGORIE_FAILURE));
        }, (_) {
          emit(Finished());
        });
      } else if (event is LoadCategories) {
        final loadCategorieEither = await loadUseCase.categorieRepository.loadAll(event.categorieType);
        loadCategorieEither.fold((failure) {
          emit(const Error(message: LOAD_CATEGORIES_FAILURE));
        }, (categories) {
          emit(Loaded(categorie: categories));
        });
      }
    });
  }
}
