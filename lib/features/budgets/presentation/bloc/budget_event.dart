part of 'budget_bloc.dart';

sealed class BudgetEvent extends Equatable {
  const BudgetEvent();
}

class CreateBudget extends BudgetEvent {
  final Budget budget;

  const CreateBudget(this.budget);

  @override
  List<Object?> get props => [budget];
}

class EditBudget extends BudgetEvent {
  final Budget budget;

  const EditBudget(this.budget);

  @override
  List<Object?> get props => [budget];
}

class DeleteBudget extends BudgetEvent {
  final Budget budget;

  const DeleteBudget(this.budget);

  @override
  List<Object?> get props => [budget];
}

class LoadMonthlyBudgets extends BudgetEvent {
  final DateTime selectedDate;

  const LoadMonthlyBudgets(this.selectedDate);

  @override
  List<Object?> get props => [selectedDate];
}

class LoadAndCalculateMonthlyBudgets extends BudgetEvent {
  final List<Booking> bookings;
  final DateTime selectedDate;

  const LoadAndCalculateMonthlyBudgets(this.bookings, this.selectedDate);

  @override
  List<Object?> get props => [bookings, selectedDate];
}
