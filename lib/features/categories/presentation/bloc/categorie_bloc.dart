import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:moneybook/features/categories/domain/usecases/delete.dart';
import 'package:moneybook/features/categories/domain/usecases/edit.dart';
import 'package:moneybook/features/categories/domain/value_objects/categorie_type.dart';

import '../../../categories/domain/usecases/create.dart';
import '../../domain/entities/categorie.dart';
import '../../domain/usecases/get_id.dart';
import '../../domain/usecases/load_all.dart';

part 'categorie_event.dart';
part 'categorie_state.dart';

const String CREATE_CATEGORIE_FAILURE = 'Kategorie konnte nicht erstellt werden.';
const String EDIT_CATEGORIE_FAILURE = 'Kategorie konnte nicht bearbeitet werden.';
const String DELETE_CATEGORIE_FAILURE = 'Kategorie konnte nicht gelöscht werden.';
const String LOAD_CATEGORIES_FAILURE = 'Kategorien konnten nicht geladen werden.';
const String GET_ID_CATEGORIE_FAILURE = 'Kategorie Id konnte nicht geladen werden.';

class CategorieBloc extends Bloc<CategorieEvent, CategorieState> {
  final Create createUseCase;
  final Edit editUseCase;
  final Delete deleteUseCase;
  final LoadAll loadUseCase;
  final GetId getIdUseCase;

  CategorieBloc(this.createUseCase, this.editUseCase, this.deleteUseCase, this.loadUseCase, this.getIdUseCase) : super(Initial()) {
    on<CategorieEvent>((event, emit) async {
      if (event is CreateCategorie) {
        final createCategorieEither = await createUseCase.categorieRepository.create(event.categorie);
        createCategorieEither.fold((failure) {
          emit(const Error(message: CREATE_CATEGORIE_FAILURE));
        }, (_) {
          emit(Finished());
        });
      } else if (event is EditCategorie) {
        final editCategorieEither = await editUseCase.categorieRepository.edit(event.categorie);
        editCategorieEither.fold((failure) {
          emit(const Error(message: EDIT_CATEGORIE_FAILURE));
        }, (_) {
          emit(Finished());
        });
      } else if (event is DeleteCategorie) {
        final deleteCategorieEither = await deleteUseCase.categorieRepository.delete(event.categorieId);
        deleteCategorieEither.fold((failure) {
          emit(const Error(message: DELETE_CATEGORIE_FAILURE));
        }, (_) {
          emit(Deleted());
        });
      } else if (event is GetCategorieId) {
        final getIdCategorieEither = await editUseCase.categorieRepository.getId(event.categorieName, event.categorieType);
        getIdCategorieEither.fold((failure) {
          emit(const Error(message: GET_ID_CATEGORIE_FAILURE));
        }, (categorie) {
          emit(ReceivedCategorie(categorie: categorie));
        });
      } else if (event is LoadCategoriesWithIds) {
        final loadCategorieWithIdsEither = await loadUseCase.categorieRepository.load(event.ids);
        loadCategorieWithIdsEither.fold((failure) {
          emit(const Error(message: LOAD_CATEGORIES_FAILURE));
        }, (categories) {
          emit(ReceivedCategories(categories: categories));
        });
      } else if (event is LoadAllCategories) {
        emit(Loading());
        final loadCategorieEither = await loadUseCase.categorieRepository.loadAll();
        loadCategorieEither.fold((failure) {
          emit(const Error(message: LOAD_CATEGORIES_FAILURE));
        }, (categories) {
          List<Categorie> expenseCategories = [];
          List<Categorie> incomeCategories = [];
          List<Categorie> investmentCategories = [];
          for (int i = 0; i < categories.length; i++) {
            if (categories[i].type == CategorieType.expense) {
              expenseCategories.add(categories[i]);
            } else if (categories[i].type == CategorieType.income) {
              incomeCategories.add(categories[i]);
            } else if (categories[i].type == CategorieType.investment) {
              investmentCategories.add(categories[i]);
            }
          }
          emit(Loaded(
            expenseCategories: expenseCategories,
            incomeCategories: incomeCategories,
            investmentCategories: investmentCategories,
          ));
        });
      }
    });
  }
}
