import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moneybook/features/accounts/domain/entities/account.dart';
import 'package:moneybook/features/accounts/domain/usecases/create.dart';

part 'account_event.dart';
part 'account_state.dart';

const String CREATE_ACCOUNT_FAILURE = 'Konto konnte nicht erstellt werden.';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final Create createUseCase;

  AccountBloc(this.createUseCase) : super(Initial()) {
    on<AccountEvent>((event, emit) async {
      if (event is CreateAccount) {
        final createAccountEither = await createUseCase.accountRepository.create(event.account);
        createAccountEither.fold((failure) {
          emit(const Error(message: CREATE_ACCOUNT_FAILURE));
        }, (_) {
          emit(Finished());
        });
      }
    });
  }
}
