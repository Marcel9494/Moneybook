import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/consts/route_consts.dart';
import '../../../../shared/presentation/widgets/arguments/bottom_nav_bar_arguments.dart';
import '../../../user/domain/usecases/create.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/checkFirstStart.dart';

part 'user_event.dart';
part 'user_state.dart';

const String CREATE_USER_FAILURE = 'Benutzer konnte nicht erstellt werden.';

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
          // TODO emit(const Error(message: CREATE_USER_FAILURE));
        }, (isFirstStart) {
          print("Erster Start $isFirstStart");
          if (isFirstStart == false) {
            Navigator.popAndPushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarArguments(0));
          }
        });
      }
    });
  }
}
