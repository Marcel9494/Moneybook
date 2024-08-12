import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:moneybook/core/consts/common_consts.dart';

import '../../../../core/consts/route_consts.dart';
import '../../../../shared/presentation/widgets/arguments/bottom_nav_bar_arguments.dart';
import '../../../bookings/domain/entities/booking.dart';
import '../../data/models/budget_model.dart';
import '../../domain/entities/budget.dart';
import '../../domain/usecases/create.dart';
import '../../domain/usecases/delete.dart';
import '../../domain/usecases/edit.dart';
import '../../domain/usecases/load_monthly.dart';

part 'budget_event.dart';
part 'budget_state.dart';

const String CREATE_BUDGET_FAILURE = 'Budget konnte nicht erstellt werden.';
const String EDIT_BUDGET_FAILURE = 'Budget konnte nicht bearbeitet werden.';
const String DELETE_BUDGET_FAILURE = 'Budget konnte nicht gelöscht werden.';
const String LOAD_BUDGETS_FAILURE = 'Budgets konnten nicht geladen werden.';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final Create createUseCase;
  final Edit editUseCase;
  final Delete deleteUseCase;
  final LoadMonthly loadMonthlyUseCase;

  BudgetBloc(this.createUseCase, this.editUseCase, this.deleteUseCase, this.loadMonthlyUseCase) : super(Initial()) {
    on<BudgetEvent>((event, emit) async {
      // TODO folgende Funktionalitäten auf einen Rutsch implementieren: Edit, Delete
      if (event is CreateBudget) {
        List<Budget> budgets = [];
        var createBudgetEither = await createUseCase.budgetRepository.create(event.budget);
        budgets.add(event.budget);
        for (int i = 0; i < 12 * serieYears; i++) {
          DateTime originalDate = DateTime.parse(event.budget.date.toString());
          DateTime nextDate = DateTime(originalDate.year, originalDate.month + (i + 1), 1);
          Budget nextBudget = event.budget.copyWith(date: nextDate);
          createBudgetEither = await createUseCase.budgetRepository.create(nextBudget);
          budgets.add(nextBudget);
        }
        print(event.budget);
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
        final editBudgetEither = await editUseCase.budgetRepository.edit(event.budget);
        editBudgetEither.fold((failure) {
          emit(const Error(message: EDIT_BUDGET_FAILURE));
        }, (_) {
          Navigator.pop(event.context);
          Navigator.popAndPushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarArguments(3));
        });
      } else if (event is DeleteBudget) {
        final deleteBudgetEither = await deleteUseCase.budgetRepository.edit(event.budget);
        deleteBudgetEither.fold((failure) {
          emit(const Error(message: DELETE_BUDGET_FAILURE));
        }, (_) {
          Navigator.pop(event.context);
          Navigator.pop(event.context);
          Navigator.popAndPushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarArguments(3));
        });
      }
    });
  }
}
