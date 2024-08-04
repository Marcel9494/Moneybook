import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
      // TODO folgende Funktionalitäten auf einen Rutsch implementieren: Create, Edit, Delete, Load & LoadAll
      // TODO hier weitermachen und LoadBudgets und CalculateBudgets in einem Event handeln.
      if (event is LoadAndCalculateMonthlyBudgets) {
        final loadBudgetEither = await loadMonthlyUseCase.budgetRepository.loadMonthly(event.selectedDate);
        loadBudgetEither.fold((failure) {
          emit(const Error(message: LOAD_BUDGETS_FAILURE));
        }, (budgets) {
          for (int i = 0; i < event.bookings.length; i++) {
            for (int j = 0; j < budgets.length; j++) {
              if (event.bookings[i].categorie == budgets[j].categorie.name) {
                budgets[j].used += event.bookings[i].amount;
                break;
              }
            }
          }
          for (int i = 0; i < budgets.length; i++) {
            budgets[i].remaining = budgets[i].amount - budgets[i].used;
            budgets[i].percentage = (budgets[i].used / budgets[i].amount) * 100;
          }
          budgets.sort((first, second) => second.percentage.compareTo(first.percentage));
          emit(Loaded(budgets: budgets));
        });
      } else if (event is CreateBudget) {
        final createBudgetEither = await createUseCase.budgetRepository.create(event.budget);
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
      }
    });
  }
}
