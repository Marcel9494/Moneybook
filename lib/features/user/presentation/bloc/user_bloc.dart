import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../user/domain/usecases/create.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/checkFirstStart.dart';

part 'user_event.dart';
part 'user_state.dart';

const String CREATE_USER_FAILURE = 'Benutzer konnte nicht erstellt werden.';
const String CHECK_FIRST_START_FAILURE = 'Erster Aufruf der App konnte nicht abgerufen werden.';

class UserBloc extends Bloc<UserEvent, UserState> {
  final Create createUseCase;
  final FirstStart checkFirstStartUseCase;

  UserBloc(this.createUseCase, this.checkFirstStartUseCase) : super(Initial()) {
    on<UserEvent>((event, emit) async {
      if (event is CreateUser) {
        final createUserEither = await createUseCase.userRepository.create(event.user);
        createUserEither.fold((failure) {
          // TODO emit(const Error(message: CREATE_USER_FAILURE));
        }, (_) {
          emit(Created());
        });
      } else if (event is CheckFirstStart) {
        final checkFirstStartEither = await checkFirstStartUseCase.userRepository.checkFirstStart();
        checkFirstStartEither.fold((failure) {
          // TODO emit(const Error(message: CHECK_FIRST_START_FAILURE));
        }, (isFirstStart) {
          emit(FirstStartChecked(isFirstStart: isFirstStart));
        });
      }
    });
  }
}
