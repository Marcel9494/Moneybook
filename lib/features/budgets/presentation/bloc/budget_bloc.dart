import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:moneybook/core/consts/common_consts.dart';
import 'package:moneybook/shared/domain/value_objects/serie_mode_type.dart';

import '../../../../core/consts/route_consts.dart';
import '../../../../shared/presentation/widgets/arguments/bottom_nav_bar_arguments.dart';
import '../../../bookings/domain/entities/booking.dart';
import '../../data/models/budget_model.dart';
import '../../domain/entities/budget.dart';
import '../../domain/usecases/create.dart';
import '../../domain/usecases/delete.dart';
import '../../domain/usecases/edit.dart';
import '../../domain/usecases/load_monthly.dart';
import '../../domain/usecases/update_all_budgets_with_categorie.dart';

part 'budget_event.dart';
part 'budget_state.dart';

const String CREATE_BUDGET_FAILURE = 'Budget konnte nicht erstellt werden.';
const String EDIT_BUDGET_FAILURE = 'Budget konnte nicht bearbeitet werden.';
const String DELETE_BUDGET_FAILURE = 'Budget konnte nicht gelöscht werden.';
const String LOAD_BUDGETS_FAILURE = 'Budgets konnten nicht geladen werden.';
const String UPDATE_ALL_BUDGETS_FAILURE = 'Budgets konnten nicht aktualisiert werden.';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final Create createUseCase;
  final Edit editUseCase;
  final Delete deleteUseCase;
  final LoadMonthly loadMonthlyUseCase;
  final UpdateAllBudgetsWithCategorie updateAllBudgetsWithCategorieUseCase;

  BudgetBloc(this.createUseCase, this.editUseCase, this.deleteUseCase, this.loadMonthlyUseCase, this.updateAllBudgetsWithCategorieUseCase)
      : super(Initial()) {
    on<BudgetEvent>((event, emit) async {
      if (event is CreateBudget) {
        var createBudgetEither = await createUseCase.budgetRepository.create(event.budget);
        for (int i = 0; i < 12 * serieYears; i++) {
          DateTime originalDate = DateTime.parse(event.budget.date.toString());
          DateTime nextDate = DateTime(originalDate.year, originalDate.month + (i + 1), 1);
          Budget nextBudget = event.budget.copyWith(date: nextDate);
          createBudgetEither = await createUseCase.budgetRepository.create(nextBudget);
        }
        createBudgetEither.fold((failure) {
          emit(const Error(message: CREATE_BUDGET_FAILURE));
        }, (_) {
          emit(Finished());
        });
      } else if (event is LoadMonthlyBudgets) {
        final loadBudgetEither = await loadMonthlyUseCase.budgetRepository.loadMonthly(event.selectedDate);
        loadBudgetEither.fold((failure) {
          emit(const Error(message: LOAD_BUDGETS_FAILURE));
        }, (budgets) {
          emit(Loaded(budgets: budgets));
        });
      } else if (event is EditBudget) {
        var editBudgetEither = await editUseCase.budgetRepository.edit(event.budget, event.serieMode);
        editBudgetEither.fold((failure) {
          emit(const Error(message: EDIT_BUDGET_FAILURE));
        }, (_) {
          Navigator.pop(event.context);
          Navigator.popAndPushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarArguments(3));
        });
      } else if (event is DeleteBudget) {
        final deleteBudgetEither = await deleteUseCase.budgetRepository.delete(event.budget, event.serieMode);
        deleteBudgetEither.fold((failure) {
          emit(const Error(message: DELETE_BUDGET_FAILURE));
        }, (_) {
          Navigator.pop(event.context);
          Navigator.pop(event.context);
          Navigator.popAndPushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarArguments(3));
        });
      } else if (event is UpdateBudgetsWithCategorie) {
        final updateAllBudgetsEither =
            await updateAllBudgetsWithCategorieUseCase.budgetRepository.updateAllBudgetsWithCategorie(event.oldCategorie, event.newCategorie);
        updateAllBudgetsEither.fold((failure) {
          emit(const Error(message: UPDATE_ALL_BUDGETS_FAILURE));
        }, (_) {});
      }
    });
  }
}
