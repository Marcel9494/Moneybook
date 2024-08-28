import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/consts/route_consts.dart';
import '../../data/usecases/createDb.dart';
import '../../data/usecases/createStartDbValues.dart';
import '../../data/usecases/existsDb.dart';
import '../widgets/arguments/bottom_nav_bar_arguments.dart';

part 'shared_event.dart';
part 'shared_state.dart';

const String CREATE_DATABASE_FAILURE = 'Datenbank mit Tabellen konnte nicht erstellt werden.';
const String CREATE_START_DATABASE_VALUES_FAILURE = 'Datenbank Start Werte konnten nicht erstellt werden.';
const String DATABASE_EXISTS_FAILURE = 'Datenbank konnte nicht abgefragt werden, ob diese bereits existiert.';

class SharedBloc extends Bloc<SharedEvent, SharedState> {
  final CreateDb createDbUseCase;
  final CreateStartDbValues createStartDbValues;
  final ExistsDb existsDb;

  SharedBloc(this.createDbUseCase, this.createStartDbValues, this.existsDb) : super(Initial()) {
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
      } else if (event is DatabaseExists) {
        final databaseExistsEither = await existsDb.sharedRepository.existsDb();
        databaseExistsEither.fold((failure) {
          emit(const Error(message: DATABASE_EXISTS_FAILURE));
        }, (dbExists) {
          print(dbExists);
          if (dbExists) {
            Navigator.popAndPushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarArguments(0));
          } /* else {
            Navigator.pushNamed(event.context, introductionRoute);
          }*/
          //emit(Exists(exists: exists));
        });
      }
    });
  }
}
