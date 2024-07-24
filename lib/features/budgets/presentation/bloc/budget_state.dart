part of 'budget_bloc.dart';

sealed class BudgetState extends Equatable {
  const BudgetState();
}

final class Initial extends BudgetState {
  @override
  List<Object> get props => [];
}

final class Loading extends BudgetState {
  @override
  List<Object> get props => [];
}

final class Loaded extends BudgetState {
  final List<Budget> budgets;

  const Loaded({required this.budgets});

  @override
  List<Object> get props => [budgets];
}

final class Finished extends BudgetState {
  @override
  List<Object> get props => [];
}

final class Error extends BudgetState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}
