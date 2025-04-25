part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();
}

class CreateUser extends UserEvent {
  final User user;

  const CreateUser({required this.user});

  @override
  List<Object?> get props => [user];
}

class CheckFirstStart extends UserEvent {
  const CheckFirstStart();

  @override
  List<Object?> get props => [];
}

class UpdateLanguage extends UserEvent {
  final String newLanguageCode;

  const UpdateLanguage({required this.newLanguageCode});

  @override
  List<Object?> get props => [newLanguageCode];
}

class UpdateCurrency extends UserEvent {
  final String newCurrency;
  final bool convertBudgetAmounts;

  const UpdateCurrency({required this.newCurrency, required this.convertBudgetAmounts});

  @override
  List<Object?> get props => [newCurrency, convertBudgetAmounts];
}

class GetLanguage extends UserEvent {
  const GetLanguage();

  @override
  List<Object?> get props => [];
}
