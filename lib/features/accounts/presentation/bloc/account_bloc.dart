import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moneybook/features/accounts/domain/entities/account.dart';
import 'package:moneybook/features/accounts/domain/usecases/create.dart';

import '../../../accounts/domain/usecases/delete.dart';
import '../../../accounts/domain/usecases/edit.dart';
import '../../../accounts/domain/usecases/load_all_accounts.dart';
import '../../../bookings/domain/entities/booking.dart';
import '../../domain/usecases/check_account_name.dart';
import '../../domain/usecases/load_filtered_accounts.dart';

part 'account_event.dart';
part 'account_state.dart';

const String CREATE_ACCOUNT_FAILURE = 'Konto konnte nicht erstellt werden.';
const String EDIT_ACCOUNT_FAILURE = 'Konto konnte nicht bearbeitet werden.';
const String DELETE_ACCOUNT_FAILURE = 'Konto konnte nicht gelöscht werden.';
const String LOAD_ACCOUNTS_FAILURE = 'Kontoliste konnte nicht geladen werden.';
const String ACCOUNT_DEPOSIT_FAILURE = 'Kontoeinzahlung konnte nicht durchgeführt werden.';
const String ACCOUNT_WITHDRAW_FAILURE = 'Kontoabhebung konnte nicht durchgeführt werden.';
const String ACCOUNT_TRANSFER_FAILURE = 'Kontotransfer konnte nicht durchgeführt werden.';
const String ACCOUNT_TRANSFER_BACK_FAILURE = 'Kontorücktransfer konnte nicht durchgeführt werden.';
const String ACCOUNT_NAME_EXISTS_FAILURE = 'Kontoname konnte nicht geprüft werden.';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final Create createUseCase;
  final Edit editUseCase;
  final Delete deleteUseCase;
  final LoadAllAccounts loadAllAccountsUseCase;
  final LoadFilteredAccounts loadAccountsWithFilterUseCase;
  final CheckAccountName checkAccountNameUseCase;

  AccountBloc(this.createUseCase, this.editUseCase, this.deleteUseCase, this.loadAllAccountsUseCase, this.loadAccountsWithFilterUseCase,
      this.checkAccountNameUseCase)
      : super(Initial()) {
    on<AccountEvent>((event, emit) async {
      if (event is CreateAccount) {
        final createAccountEither = await createUseCase.accountRepository.create(event.account);
        createAccountEither.fold((failure) {
          emit(const Error(message: CREATE_ACCOUNT_FAILURE));
        }, (_) {
          emit(Finished());
        });
      } else if (event is EditAccount) {
        final editAccountEither = await editUseCase.accountRepository.edit(event.account);
        editAccountEither.fold((failure) {
          emit(const Error(message: EDIT_ACCOUNT_FAILURE));
        }, (_) {
          emit(Finished());
        });
      } else if (event is DeleteAccount) {
        final deleteAccountEither = await deleteUseCase.accountRepository.delete(event.accountId);
        deleteAccountEither.fold((failure) {
          emit(const Error(message: DELETE_ACCOUNT_FAILURE));
        }, (_) {
          emit(Deleted());
        });
      } else if (event is LoadAccounts) {
        final loadAccountEither = await loadAllAccountsUseCase.accountRepository.loadAll();
        loadAccountEither.fold((failure) {
          emit(const Error(message: LOAD_ACCOUNTS_FAILURE));
        }, (accounts) {
          emit(Loaded(accounts: accounts));
        });
      } else if (event is LoadAccountsWithFilter) {
        final loadAccountWithFilterEither = await loadAccountsWithFilterUseCase.accountRepository.loadAccountsWithFilter(event.accountNameFilter);
        loadAccountWithFilterEither.fold((failure) {
          emit(const Error(message: LOAD_ACCOUNTS_FAILURE));
        }, (filteredAccounts) {
          emit(FilteredLoaded(filteredAccounts: filteredAccounts));
        });
      } else if (event is AccountDeposit) {
        if (event.force == false) {
          if (event.booking.date.isAfter(DateTime.now())) {
            emit(Booked(id: event.bookedId));
            return;
          }
        }
        final accountDepositEither = await createUseCase.accountRepository.deposit(event.booking);
        accountDepositEither.fold((failure) {
          emit(const Error(message: ACCOUNT_DEPOSIT_FAILURE));
        }, (_) {
          emit(Booked(id: event.bookedId));
        });
      } else if (event is AccountWithdraw) {
        if (event.force == false) {
          if (event.booking.date.isAfter(DateTime.now())) {
            emit(Booked(id: event.bookedId));
            return;
          }
        }
        final accountWithdrawEither = await createUseCase.accountRepository.withdraw(event.booking);
        accountWithdrawEither.fold((failure) {
          emit(const Error(message: ACCOUNT_WITHDRAW_FAILURE));
        }, (_) {
          emit(Booked(id: event.bookedId));
        });
      } else if (event is AccountTransfer) {
        if (event.force == false) {
          if (event.booking.date.isAfter(DateTime.now())) {
            emit(Booked(id: event.bookedId));
            return;
          }
        }
        final accountTransferEither = await createUseCase.accountRepository.transfer(event.booking);
        accountTransferEither.fold((failure) {
          emit(const Error(message: ACCOUNT_TRANSFER_FAILURE));
        }, (_) {
          emit(Booked(id: event.bookedId));
        });
      } else if (event is AccountTransferBack) {
        if (event.force == false) {
          if (event.booking.date.isAfter(DateTime.now())) {
            emit(Booked(id: event.bookedId));
            return;
          }
        }
        final accountTransferBackEither = await createUseCase.accountRepository.transferBack(event.booking);
        accountTransferBackEither.fold((failure) {
          emit(const Error(message: ACCOUNT_TRANSFER_BACK_FAILURE));
        }, (_) {
          emit(Booked(id: event.bookedId));
        });
      } else if (event is CheckAccountNameExists) {
        final checkAccountNameExistsEither = await checkAccountNameUseCase.accountRepository.checkAccountName(event.accountName);
        checkAccountNameExistsEither.fold((failure) {
          emit(const Error(message: ACCOUNT_NAME_EXISTS_FAILURE));
        }, (accountNameExists) {
          emit(CheckedAccountName(accountNameExists: accountNameExists, numberOfEventCalls: event.numberOfEventCalls));
        });
      }
    });
  }
}
