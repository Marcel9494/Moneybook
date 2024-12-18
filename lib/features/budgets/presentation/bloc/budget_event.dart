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
  final SerieModeType serieMode;
  final BuildContext context;

  const EditBudget(this.budget, this.serieMode, this.context);

  @override
  List<Object?> get props => [budget, serieMode];
}

class DeleteBudget extends BudgetEvent {
  final Budget budget;
  final SerieModeType serieMode;
  final BuildContext context;

  const DeleteBudget(this.budget, this.serieMode, this.context);

  @override
  List<Object?> get props => [budget, serieMode];
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

class UpdateBudgetsWithCategorie extends BudgetEvent {
  final String oldCategorie;
  final String newCategorie;

  const UpdateBudgetsWithCategorie(this.oldCategorie, this.newCategorie);

  @override
  List<Object?> get props => [oldCategorie, newCategorie];
}
