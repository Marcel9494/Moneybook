import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../goals/domain/usecases/create.dart';
import '../../../goals/domain/usecases/delete.dart';
import '../../../goals/domain/usecases/load.dart';
import '../../../goals/domain/usecases/loadAll.dart';
import '../../../goals/domain/usecases/update.dart';
import '../../domain/entities/goal.dart';

part 'goal_event.dart';
part 'goal_state.dart';

const String CREATE_GOAL_FAILURE = 'Ziel konnte nicht erstellt werden.';
const String UPDATE_GOAL_FAILURE = 'Ziel konnte nicht bearbeitet werden.';
const String DELETE_GOAL_FAILURE = 'Ziel konnte nicht gelöscht werden.';
const String LOAD_GOAL_FAILURE = 'Ziel konnte nicht geladen werden.';
const String LOAD_ALL_GOALS_FAILURE = 'Ziele konnten nicht geladen werden.';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  final Create createUseCase;
  final Update updateUseCase;
  final Delete deleteUseCase;
  final Load loadUseCase;
  final LoadAll loadAllUseCase;

  GoalBloc(
    this.createUseCase,
    this.updateUseCase,
    this.deleteUseCase,
    this.loadUseCase,
    this.loadAllUseCase,
  ) : super(GoalInitial()) {
    on<GoalEvent>((event, emit) async {
      if (event is CreateGoal) {
        final createGoalEither = await createUseCase.goalRepository.create(event.goal);
        createGoalEither.fold((failure) {
          emit(const Error(message: CREATE_GOAL_FAILURE));
        }, (_) {
          emit(Finished());
        });
      } else if (event is UpdateGoal) {
        final updateGoalEither = await updateUseCase.goalRepository.update(event.goal);
        updateGoalEither.fold((failure) {
          emit(const Error(message: UPDATE_GOAL_FAILURE));
        }, (_) {
          emit(Finished());
        });
      } else if (event is DeleteGoal) {
        final deleteGoalEither = await deleteUseCase.goalRepository.delete(event.goalId);
        deleteGoalEither.fold((failure) {
          emit(const Error(message: DELETE_GOAL_FAILURE));
        }, (_) {
          emit(Finished());
        });
      } else if (event is LoadGoal) {
        final loadGoalEither = await loadUseCase.goalRepository.load(event.goalId);
        loadGoalEither.fold((failure) {
          emit(const Error(message: LOAD_GOAL_FAILURE));
        }, (goal) {
          emit(Loaded(goal: goal));
        });
      } else if (event is LoadAllGoals) {
        final loadAllGoalsEither = await loadAllUseCase.goalRepository.loadAll();
        loadAllGoalsEither.fold((failure) {
          emit(const Error(message: LOAD_ALL_GOALS_FAILURE));
        }, (goals) {
          emit(LoadedAll(goals: goals));
        });
      }
    });
  }
}
