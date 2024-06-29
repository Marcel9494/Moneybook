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

final class Error extends AccountState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}
