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

class EditAccount extends AccountEvent {
  final Account account;

  const EditAccount(this.account);

  @override
  List<Object?> get props => [account];
}

class DeleteAccount extends AccountEvent {
  final int accountId;

  const DeleteAccount(this.accountId);

  @override
  List<Object?> get props => [accountId];
}

class LoadAllAccounts extends AccountEvent {
  const LoadAllAccounts();

  @override
  List<Object?> get props => [];
}
