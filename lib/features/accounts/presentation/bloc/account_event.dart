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
  @override
  List<Object?> get props => [];
}

class LoadAccountsWithFilter extends AccountEvent {
  final List<String> accountNameFilter;

  const LoadAccountsWithFilter(this.accountNameFilter);

  @override
  List<Object?> get props => [accountNameFilter];
}

class AccountDeposit extends AccountEvent {
  final Booking booking;

  const AccountDeposit(this.booking);

  @override
  List<Object?> get props => [booking];
}

class AccountWithdraw extends AccountEvent {
  final Booking booking;

  const AccountWithdraw(this.booking);

  @override
  List<Object?> get props => [booking];
}

class AccountTransfer extends AccountEvent {
  final Booking booking;

  const AccountTransfer(this.booking);

  @override
  List<Object?> get props => [booking];
}

class CheckAccountNameExists extends AccountEvent {
  final String accountName;
  int numberOfEventCalls;

  CheckAccountNameExists(this.accountName, this.numberOfEventCalls);

  @override
  List<Object?> get props => [accountName, numberOfEventCalls];
}
