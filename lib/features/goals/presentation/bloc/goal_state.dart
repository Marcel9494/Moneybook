part of 'goal_bloc.dart';

@immutable
sealed class GoalState extends Equatable {
  const GoalState();
}

final class GoalInitial extends GoalState {
  @override
  List<Object> get props => [];
}

final class GoalLoading extends GoalState {
  @override
  List<Object> get props => [];
}

final class AllGoalsLoadedSuccessful extends GoalState {
  final List<Goal> goals;

  AllGoalsLoadedSuccessful({required this.goals});

  @override
  List<Object> get props => [goals];
}

final class AllGoalsLoadedFailure extends GoalState {
  final String message;

  AllGoalsLoadedFailure({required this.message});

  @override
  List<Object> get props => [message];
}

final class Finished extends GoalState {
  @override
  List<Object> get props => [];
}

final class Error extends GoalState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}
