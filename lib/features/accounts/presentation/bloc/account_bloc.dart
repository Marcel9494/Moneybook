import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moneybook/features/accounts/domain/entities/account.dart';
import 'package:moneybook/features/accounts/domain/usecases/create.dart';

import '../../../accounts/domain/usecases/delete.dart';
import '../../../accounts/domain/usecases/edit.dart';
import '../../../accounts/domain/usecases/load_all_categories.dart';

part 'account_event.dart';
part 'account_state.dart';

const String CREATE_ACCOUNT_FAILURE = 'Konto konnte nicht erstellt werden.';
const String EDIT_ACCOUNT_FAILURE = 'Konto konnte nicht bearbeitet werden.';
const String DELETE_ACCOUNT_FAILURE = 'Konto konnte nicht gelöscht werden.';
const String LOAD_ACCOUNTS_FAILURE = 'Kontoliste konnte nicht geladen werden.';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final Create createUseCase;
  final Edit editUseCase;
  final Delete deleteUseCase;
  final LoadAllCategories loadAllCategoriesUseCase;

  AccountBloc(this.createUseCase, this.editUseCase, this.deleteUseCase, this.loadAllCategoriesUseCase) : super(Initial()) {
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
          // TODO state emitten
        });
      } else if (event is DeleteAccount) {
        final deleteAccountEither = await deleteUseCase.accountRepository.delete(event.accountId);
        deleteAccountEither.fold((failure) {
          emit(const Error(message: DELETE_ACCOUNT_FAILURE));
        }, (_) {
          // TODO state emitten
        });
      } else if (event is LoadAllAccounts) {
        final loadAccountEither = await loadAllCategoriesUseCase.accountRepository.loadAll();
        loadAccountEither.fold((failure) {
          emit(const Error(message: LOAD_ACCOUNTS_FAILURE));
        }, (accounts) {
          emit(Loaded(accounts: accounts));
        });
      }
    });
  }
}
