part of 'goal_bloc.dart';

@immutable
sealed class GoalEvent extends Equatable {
  const GoalEvent();
}

class CreateGoal extends GoalEvent {
  final Goal goal;

  const CreateGoal(this.goal);

  @override
  List<Object?> get props => [goal];
}

class UpdateGoal extends GoalEvent {
  final Goal goal;

  const UpdateGoal(this.goal);

  @override
  List<Object?> get props => [goal];
}

class DeleteGoal extends GoalEvent {
  final int goalId;

  const DeleteGoal(this.goalId);

  @override
  List<Object?> get props => [goalId];
}

class LoadGoal extends GoalEvent {
  final int goalId;

  const LoadGoal(this.goalId);

  @override
  List<Object?> get props => [goalId];
}

class LoadAllGoals extends GoalEvent {
  const LoadAllGoals();

  @override
  List<Object?> get props => [];
}
