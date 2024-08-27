import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/usecases/createDb.dart';
import '../../data/usecases/createStartDbValues.dart';

part 'shared_event.dart';
part 'shared_state.dart';

const String CREATE_DATABASE_FAILURE = 'Datenbank mit Tabellen konnte nicht erstellt werden.';
const String CREATE_START_DATABASE_VALUES_FAILURE = 'Datenbank Start Werte konnten nicht erstellt werden.';

class SharedBloc extends Bloc<SharedEvent, SharedState> {
  final CreateDb createDbUseCase;
  final CreateStartDbValues createStartDbValues;

  SharedBloc(this.createDbUseCase, this.createStartDbValues) : super(Initial()) {
    on<SharedEvent>((event, emit) async {
      if (event is CreateDatabase) {
        final createDbEither = await createDbUseCase.sharedRepository.createDb();
        createDbEither.fold((failure) {
          emit(const Error(message: CREATE_DATABASE_FAILURE));
        }, (_) {
          emit(Created());
        });
      } else if (event is CreateStartDatabaseValues) {
        final createStartDbValuesEither = await createStartDbValues.sharedRepository.createStartDbValues();
        createStartDbValuesEither.fold((failure) {
          emit(const Error(message: CREATE_START_DATABASE_VALUES_FAILURE));
        }, (_) {
          emit(Created());
        });
      }
    });
  }
}
