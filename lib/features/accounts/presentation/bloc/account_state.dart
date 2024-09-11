part of 'account_bloc.dart';

sealed class AccountState extends Equatable {
  const AccountState();
}

final class Initial extends AccountState {
  @override
  List<Object> get props => [];
}

final class Loading extends AccountState {
  @override
  List<Object> get props => [];
}

final class Loaded extends AccountState {
  final List<Account> accounts;

  const Loaded({required this.accounts});

  @override
  List<Object> get props => [accounts];
}

final class Finished extends AccountState {
  @override
  List<Object> get props => [];
}

final class Booked extends AccountState {
  @override
  List<Object> get props => [];
}

final class CheckedAccountName extends AccountState {
  final bool accountNameExists;
  final int numberOfEventCalls;

  const CheckedAccountName({required this.accountNameExists, required this.numberOfEventCalls});

  @override
  List<Object> get props => [accountNameExists, numberOfEventCalls];
}

final class Error extends AccountState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}
