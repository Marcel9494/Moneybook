part of 'account_bloc.dart';

sealed class AccountState extends Equatable {
  const AccountState();
}

final class Initial extends AccountState {
  @override
  List<Object> get props => [];
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
