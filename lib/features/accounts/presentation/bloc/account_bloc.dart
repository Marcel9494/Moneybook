import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(Initial()) {
    on<AccountEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
