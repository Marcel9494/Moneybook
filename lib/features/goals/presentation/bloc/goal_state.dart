part of 'goal_bloc.dart';

@immutable
sealed class GoalState extends Equatable {
  const GoalState();
}

final class GoalInitial extends GoalState {
  @override
  List<Object> get props => [];
}

final class Loaded extends GoalState {
  Goal goal;

  Loaded({required this.goal});

  @override
  List<Object> get props => [goal];
}

final class LoadedAll extends GoalState {
  List<Goal> goals;

  LoadedAll({required this.goals});

  @override
  List<Object> get props => [goals];
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
