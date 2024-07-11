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
  final bool reversal;

  const AccountTransfer(this.booking, this.reversal);

  @override
  List<Object?> get props => [booking, reversal];
}
