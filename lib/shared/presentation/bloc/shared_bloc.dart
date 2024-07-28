import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/usecases/createDb.dart';

part 'shared_event.dart';
part 'shared_state.dart';

const String CREATE_DATABASE_FAILURE = 'Datenbank mit Tabellen konnte nicht erstellt werden.';

class SharedBloc extends Bloc<SharedEvent, SharedState> {
  final CreateDb createDbUseCase;

  SharedBloc(this.createDbUseCase) : super(Initial()) {
    on<SharedEvent>((event, emit) async {
      if (event is CreateDatabase) {
        final createDbEither = await createDbUseCase.sharedRepository.createDb();
        createDbEither.fold((failure) {
          emit(const Error(message: CREATE_DATABASE_FAILURE));
        }, (_) {
          emit(Created());
        });
      }
    });
  }
}
