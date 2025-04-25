import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moneybook/features/user/domain/usecases/updateLanguageUseCase.dart';

import '../../../user/domain/usecases/create.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/checkFirstStart.dart';
import '../../domain/usecases/getLanguageUseCase.dart';
import '../../domain/usecases/update_currency_use_case.dart';

part 'user_event.dart';
part 'user_state.dart';

const String CREATE_USER_FAILURE = 'Benutzer konnte nicht erstellt werden.';
const String CHECK_FIRST_START_FAILURE = 'Erster Aufruf der App konnte nicht abgerufen werden.';

class UserBloc extends Bloc<UserEvent, UserState> {
  final Create createUseCase;
  final FirstStart checkFirstStartUseCase;
  final UpdateLanguageUseCase updateLanguageUseCase;
  final UpdateCurrencyUseCase updateCurrencyUseCase;
  final GetLanguageUseCase getLanguageUseCase;

  UserBloc(
    this.createUseCase,
    this.checkFirstStartUseCase,
    this.updateLanguageUseCase,
    this.updateCurrencyUseCase,
    this.getLanguageUseCase,
  ) : super(Initial()) {
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
      } else if (event is UpdateLanguage) {
        final updateLanguageEither = await updateLanguageUseCase.userRepository.updateLanguage(event.newLanguageCode);
        updateLanguageEither.fold((failure) {
          // TODO emit(const Error(message: CHECK_FIRST_START_FAILURE));
        }, (isFirstStart) {
          //emit(FirstStartChecked(isFirstStart: isFirstStart));
        });
      } else if (event is UpdateCurrency) {
        final updateCurrencyEither = await updateCurrencyUseCase.userRepository.updateCurrency(event.newCurrency, event.convertBudgetAmounts);
        updateCurrencyEither.fold((failure) {
          // TODO emit(const Error(message: CHECK_FIRST_START_FAILURE));
        }, (_) {
          // TODO Random().nextInt(100000000) bessere Lösung finden
          emit(CurrencyUpdated(forceRefresh: Random().nextInt(100000000)));
        });
      } else if (event is GetLanguage) {
        final getLanguageEither = await getLanguageUseCase.userRepository.getLanguage();
        getLanguageEither.fold((failure) {
          // TODO emit(const Error(message: CHECK_FIRST_START_FAILURE));
        }, (currentLanguageCode) {
          emit(CurrentLanguage(currentLanguageCode: currentLanguageCode));
        });
      }
    });
  }
}
