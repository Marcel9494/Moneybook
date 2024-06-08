part of 'account_bloc.dart';

sealed class AccountEvent extends Equatable {
  const AccountEvent();
}

class CreateAccount extends AccountEvent {
  final Account account;

  const CreateAccount(this.account);

  @override
  List<Object?> get props => [account];
}
