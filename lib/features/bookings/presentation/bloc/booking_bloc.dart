import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/core/error/failures.dart';
import 'package:moneybook/features/bookings/domain/value_objects/repetition_type.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/consts/route_consts.dart';
import '../../../../shared/presentation/widgets/arguments/bottom_nav_bar_arguments.dart';
import '../../../accounts/presentation/bloc/account_bloc.dart' as account;
import '../../../accounts/presentation/bloc/account_bloc.dart';
import '../../../categories/domain/value_objects/categorie_type.dart';
import '../../domain/entities/booking.dart';
import '../../domain/usecases/calculate_and_update_new_bookings.dart';
import '../../domain/usecases/create.dart';
import '../../domain/usecases/delete.dart';
import '../../domain/usecases/delete_all_bookings_in_serie.dart';
import '../../domain/usecases/delete_only_future_bookings_in_serie.dart';
import '../../domain/usecases/get_new_serie_id.dart';
import '../../domain/usecases/load_categorie_bookings.dart';
import '../../domain/usecases/load_monthly_amount_type_bookings.dart';
import '../../domain/usecases/load_past_categorie_bookings.dart';
import '../../domain/usecases/load_serie_bookings.dart';
import '../../domain/usecases/load_sorted_monthly_bookings.dart';
import '../../domain/usecases/translate_bookings.dart';
import '../../domain/usecases/update.dart';
import '../../domain/usecases/update_all_bookings_in_serie.dart';
import '../../domain/usecases/update_all_bookings_with_account.dart';
import '../../domain/usecases/update_all_bookings_with_categorie.dart';
import '../../domain/usecases/update_only_future_bookings_in_serie.dart';
import '../../domain/value_objects/amount_type.dart';
import '../../domain/value_objects/booking_type.dart';

part 'booking_event.dart';
part 'booking_state.dart';

const String CREATE_BOOKING_FAILURE = 'Buchung konnte nicht erstellt werden.';
const String UPDATE_BOOKING_FAILURE = 'Buchung konnte nicht bearbeitet werden.';
const String UPDATE_SERIE_BOOKINGS_FAILURE = 'Serienbuchungen konnten nicht bearbeitet werden.';
const String DELETE_BOOKING_FAILURE = 'Buchung konnte nicht gelöscht werden.';
const String DELETE_BOOKINGS_FAILURE = 'Buchungen konnten nicht gelöscht werden.';
const String LOAD_BOOKINGS_FAILURE = 'Buchungen konnten nicht geladen werden.';
const String UPDATE_ALL_BOOKINGS_FAILURE = 'Buchungen konnten nicht aktualisiert werden.';
const String NEW_BOOKINGS_FAILURE = 'Neue Buchungen konnten nicht abgefragt/aktualisiert werden.';
const String LOAD_NEW_BOOKINGS_FAILURE = 'Neue Buchungen konnten nicht geladen werden.';
const String TRANSLATE_BOOKINGS_FAILURE = 'Buchungen konnten nicht übersetzt werden.';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final Create createUseCase;
  final Update updateUseCase;
  final Delete deleteUseCase;
  final DeleteAllBookingsInSerie deleteAllSerieBookingsUseCase;
  final DeleteOnlyFutureBookingsInSerie deleteOnlyFutureSerieBookingsUseCase;
  final LoadSortedMonthly loadSortedMonthlyUseCase;
  final LoadMonthlyAmountTypeBookings loadAmountTypeMonthlyUseCase;
  final LoadAllCategorieBookings loadCategorieBookingsUseCase;
  final LoadPastCategorieBookings loadPastMonthlyCategorieBookingsUseCase;
  final LoadAllSerieBookings loadSerieBookingsUseCase;
  final UpdateAllBookingsWithCategorie updateAllBookingsWithCategorieUseCase;
  final UpdateAllBookingsWithAccount updateAllBookingsWithAccountUseCase;
  final UpdateAllBookingsInSerie updateAllBookingsInSerieUseCase;
  final UpdateOnlyFutureBookingsInSerie updateOnlyFutureBookingsInSerieUseCase;
  final CalculateAndUpdateNewBookings calculateAndUpdateNewBookingsUseCase;
  final GetNewSerieId getNewSerieIdUseCase;
  final TranslateBookings translateAllBookingsUseCase;

  BookingBloc(
    this.createUseCase,
    this.updateUseCase,
    this.deleteUseCase,
    this.deleteAllSerieBookingsUseCase,
    this.deleteOnlyFutureSerieBookingsUseCase,
    this.loadSortedMonthlyUseCase,
    this.loadAmountTypeMonthlyUseCase,
    this.loadCategorieBookingsUseCase,
    this.loadPastMonthlyCategorieBookingsUseCase,
    this.loadSerieBookingsUseCase,
    this.updateAllBookingsWithCategorieUseCase,
    this.updateAllBookingsWithAccountUseCase,
    this.updateAllBookingsInSerieUseCase,
    this.updateOnlyFutureBookingsInSerieUseCase,
    this.calculateAndUpdateNewBookingsUseCase,
    this.getNewSerieIdUseCase,
    this.translateAllBookingsUseCase,
  ) : super(Initial()) {
    on<BookingEvent>((event, emit) async {
      if (event is CreateBooking) {
        final createBookingEither = await createUseCase.bookingRepository.create(event.booking);
        createBookingEither.fold((failure) {
          emit(const Error(message: CREATE_BOOKING_FAILURE));
        }, (_) {
          emit(Finished());
        });
      } else if (event is CreateSerieBooking) {
        Either<Failure, int> getNewSerieIdEither = await getNewSerieIdUseCase.bookingRepository.getNewSerieId();
        await getNewSerieIdEither.fold((failure) {
          emit(const Error(message: CREATE_BOOKING_FAILURE));
        }, (newSerieId) async {
          List<Booking> bookings = [];
          Either<Failure, void>? createSerieBookingEither;
          event.booking = event.booking.copyWith(serieId: newSerieId);
          createSerieBookingEither = await createUseCase.bookingRepository.create(event.booking);
          bookings.add(event.booking);
          if (event.booking.repetition == RepetitionType.weekly) {
            for (int i = 0; i < 52 * serieYears; i++) {
              DateTime nextDate = DateTime.parse(event.booking.date.toString()).add(Duration(days: (i + 1) * 7));
              Booking nextBooking = event.booking.copyWith(date: nextDate);
              createSerieBookingEither = await createUseCase.bookingRepository.create(nextBooking);
              bookings.add(nextBooking);
            }
          } else if (event.booking.repetition == RepetitionType.twoWeeks) {
            for (int i = 0; i < 26 * serieYears; i++) {
              DateTime nextDate = DateTime.parse(event.booking.date.toString()).add(Duration(days: (i + 1) * 14));
              Booking nextBooking = event.booking.copyWith(date: nextDate);
              createSerieBookingEither = await createUseCase.bookingRepository.create(nextBooking);
              bookings.add(nextBooking);
            }
          } else if (event.booking.repetition == RepetitionType.monthly) {
            for (int i = 0; i < 12 * serieYears; i++) {
              DateTime originalDate = DateTime.parse(event.booking.date.toString());
              DateTime nextDate = DateTime(originalDate.year, originalDate.month + (i + 1), originalDate.day);
              Booking nextBooking = event.booking.copyWith(date: nextDate);
              createSerieBookingEither = await createUseCase.bookingRepository.create(nextBooking);
              bookings.add(nextBooking);
            }
          } else if (event.booking.repetition == RepetitionType.monthlyBeginning) {
            for (int i = 0; i < 12 * serieYears; i++) {
              DateTime originalDate = DateTime.parse(event.booking.date.toString());
              DateTime nextDate = DateTime(originalDate.year, originalDate.month + (i + 1), 1);
              Booking nextBooking = event.booking.copyWith(date: nextDate);
              createSerieBookingEither = await createUseCase.bookingRepository.create(nextBooking);
              bookings.add(nextBooking);
            }
          } else if (event.booking.repetition == RepetitionType.monthlyEnding) {
            for (int i = 0; i < 12 * serieYears; i++) {
              DateTime originalDate = DateTime.parse(event.booking.date.toString());
              DateTime nextDate = DateTime(originalDate.year, originalDate.month + (i + 2), 0);
              Booking nextBooking = event.booking.copyWith(date: nextDate);
              createSerieBookingEither = await createUseCase.bookingRepository.create(nextBooking);
              bookings.add(nextBooking);
            }
          } else if (event.booking.repetition == RepetitionType.threeMonths) {
            for (int i = 0; i < 4 * serieYears; i++) {
              DateTime originalDate = DateTime.parse(event.booking.date.toString());
              DateTime nextDate = DateTime(originalDate.year, originalDate.month + ((i + 1) * 3), originalDate.day);
              Booking nextBooking = event.booking.copyWith(date: nextDate);
              createSerieBookingEither = await createUseCase.bookingRepository.create(nextBooking);
              bookings.add(nextBooking);
            }
          } else if (event.booking.repetition == RepetitionType.sixMonths) {
            for (int i = 0; i < 2 * serieYears; i++) {
              DateTime originalDate = DateTime.parse(event.booking.date.toString());
              DateTime nextDate = DateTime(originalDate.year, originalDate.month + ((i + 1) * 6), originalDate.day);
              Booking nextBooking = event.booking.copyWith(date: nextDate);
              createSerieBookingEither = await createUseCase.bookingRepository.create(nextBooking);
              bookings.add(nextBooking);
            }
          } else if (event.booking.repetition == RepetitionType.yearly) {
            for (int i = 0; i < 1 * serieYears; i++) {
              DateTime originalDate = DateTime.parse(event.booking.date.toString());
              DateTime nextDate = DateTime(originalDate.year + (i + 1) * 1, originalDate.month, originalDate.day);
              Booking nextBooking = event.booking.copyWith(date: nextDate);
              createSerieBookingEither = await createUseCase.bookingRepository.create(nextBooking);
              bookings.add(nextBooking);
            }
          }
          createSerieBookingEither!.fold((failure) {
            emit(const Error(message: CREATE_BOOKING_FAILURE));
          }, (_) {
            emit(SerieFinished(bookings: bookings));
          });
        });
      } else if (event is UpdateBooking) {
        final editBookingEither = await updateUseCase.bookingRepository.update(event.booking);
        editBookingEither.fold((failure) {
          emit(const Error(message: UPDATE_BOOKING_FAILURE));
        }, (_) {
          Navigator.pushNamedAndRemoveUntil(event.context, bottomNavBarRoute, arguments: BottomNavBarArguments(tabIndex: 0), (route) => false);
        });
      } else if (event is UpdateOnlyFutureSerieBookings) {
        // Die Beträge der Serienbuchungen die in der Vergangenheit liegen werden zusammengerechnet und
        // das entsprechende Konto einmal aktualisiert mit dem gesamten Serienbuchungsbetrag. Datenbank
        // muss somit nur einmal aufgerufen werden.
        double overallSerieAmount = 0.0;
        for (int i = 0; i < event.oldSerieBookings.length; i++) {
          if (event.oldSerieBookings[i].date.isAfter(event.updatedBooking.date) && event.oldSerieBookings[i].date.isBefore(DateTime.now())) {
            overallSerieAmount += event.oldSerieBookings[i].amount;
          }
        }
        event.oldSerieBookings[0] = event.oldSerieBookings[0].copyWith(amount: overallSerieAmount);
        // TODO Random().nextInt(1000000) bessere Lösung finden!
        if (event.bookingType == BookingType.expense) {
          BlocProvider.of<account.AccountBloc>(event.context)
              .add(AccountDeposit(booking: event.oldSerieBookings[0], bookedId: Random().nextInt(1000000)));
        } else if (event.bookingType == BookingType.income) {
          BlocProvider.of<account.AccountBloc>(event.context)
              .add(AccountWithdraw(booking: event.oldSerieBookings[0], bookedId: Random().nextInt(1000000)));
        } else if (event.bookingType == BookingType.transfer || event.bookingType == BookingType.investment) {
          BlocProvider.of<account.AccountBloc>(event.context)
              .add(AccountTransferBack(booking: event.oldSerieBookings[0], bookedId: Random().nextInt(1000000)));
        }
        final updateSerieBookingEither = await updateOnlyFutureBookingsInSerieUseCase.bookingRepository
            .updateOnlyFutureBookingsInSerie(event.updatedBooking, event.oldSerieBookings);
        updateSerieBookingEither.fold((failure) {
          emit(const Error(message: UPDATE_SERIE_BOOKINGS_FAILURE));
        }, (newSerieBookings) {
          double overallSerieAmount = 0.0;
          for (int i = 0; i < newSerieBookings.length; i++) {
            if (newSerieBookings[i].date.isAfter(event.updatedBooking.date) && newSerieBookings[i].date.isBefore(DateTime.now())) {
              overallSerieAmount += newSerieBookings[i].amount;
            }
          }
          newSerieBookings[0] = newSerieBookings[0].copyWith(amount: overallSerieAmount);
          // TODO Random().nextInt(1000000) bessere Lösung finden!
          if (event.bookingType == BookingType.expense) {
            BlocProvider.of<account.AccountBloc>(event.context)
                .add(AccountWithdraw(booking: newSerieBookings[0], bookedId: Random().nextInt(1000000)));
          } else if (event.bookingType == BookingType.income) {
            BlocProvider.of<account.AccountBloc>(event.context)
                .add(AccountDeposit(booking: newSerieBookings[0], bookedId: Random().nextInt(1000000)));
          } else if (event.bookingType == BookingType.transfer || event.bookingType == BookingType.investment) {
            BlocProvider.of<account.AccountBloc>(event.context)
                .add(AccountTransfer(booking: newSerieBookings[0], bookedId: Random().nextInt(1000000)));
          }
          Navigator.pushNamedAndRemoveUntil(event.context, bottomNavBarRoute, arguments: BottomNavBarArguments(tabIndex: 0), (route) => false);
        });
      } else if (event is UpdateAllSerieBookings) {
        // Die Beträge der Serienbuchungen die in der Vergangenheit liegen werden zusammengerechnet und
        // das entsprechende Konto einmal aktualisiert mit dem gesamten Serienbuchungsbetrag. Datenbank
        // muss somit nur einmal aufgerufen werden.
        double overallSerieAmount = 0.0;
        for (int i = 0; i < event.oldSerieBookings.length; i++) {
          // TODO hier weitermachen und Code verbessern und DateTime auf sameDate zusätzlich prüfen?
          if (event.oldSerieBookings[i].date.isBefore(DateTime.now())) {
            overallSerieAmount += event.oldSerieBookings[i].amount;
          }
        }
        event.oldSerieBookings[0] = event.oldSerieBookings[0].copyWith(amount: overallSerieAmount);
        // TODO Random().nextInt(1000000) bessere Lösung finden!
        if (event.bookingType == BookingType.expense) {
          BlocProvider.of<account.AccountBloc>(event.context)
              .add(AccountDeposit(booking: event.oldSerieBookings[0], bookedId: Random().nextInt(1000000)));
        } else if (event.bookingType == BookingType.income) {
          BlocProvider.of<account.AccountBloc>(event.context)
              .add(AccountWithdraw(booking: event.oldSerieBookings[0], bookedId: Random().nextInt(1000000)));
        } else if (event.bookingType == BookingType.transfer || event.bookingType == BookingType.investment) {
          BlocProvider.of<account.AccountBloc>(event.context)
              .add(AccountTransferBack(booking: event.oldSerieBookings[0], bookedId: Random().nextInt(1000000)));
        }
        final updateSerieBookingEither =
            await updateAllBookingsInSerieUseCase.bookingRepository.updateAllBookingsInSerie(event.updatedBooking, event.oldSerieBookings);
        updateSerieBookingEither.fold((failure) {
          emit(const Error(message: UPDATE_SERIE_BOOKINGS_FAILURE));
        }, (newSerieBookings) {
          double overallSerieAmount = 0.0;
          for (int i = 0; i < newSerieBookings.length; i++) {
            if (newSerieBookings[i].date.isBefore(DateTime.now())) {
              overallSerieAmount += newSerieBookings[i].amount;
            }
          }
          newSerieBookings[0] = newSerieBookings[0].copyWith(amount: overallSerieAmount);
          // TODO Random().nextInt(1000000) bessere Lösung finden!
          if (event.bookingType == BookingType.expense) {
            BlocProvider.of<account.AccountBloc>(event.context)
                .add(AccountWithdraw(booking: newSerieBookings[0], bookedId: Random().nextInt(1000000)));
          } else if (event.bookingType == BookingType.income) {
            BlocProvider.of<account.AccountBloc>(event.context)
                .add(AccountDeposit(booking: newSerieBookings[0], bookedId: Random().nextInt(1000000)));
          } else if (event.bookingType == BookingType.transfer || event.bookingType == BookingType.investment) {
            BlocProvider.of<account.AccountBloc>(event.context)
                .add(AccountTransfer(booking: newSerieBookings[0], bookedId: Random().nextInt(1000000)));
          }
          Navigator.pushNamedAndRemoveUntil(event.context, bottomNavBarRoute, arguments: BottomNavBarArguments(tabIndex: 0), (route) => false);
        });
      } else if (event is DeleteBooking) {
        if (event.booking.type == BookingType.expense) {
          BlocProvider.of<account.AccountBloc>(event.context).add(account.AccountDeposit(booking: event.booking, bookedId: 0));
        } else if (event.booking.type == BookingType.income) {
          BlocProvider.of<account.AccountBloc>(event.context).add(account.AccountWithdraw(booking: event.booking, bookedId: 0));
        } else if (event.booking.type == BookingType.transfer || event.booking.type == BookingType.investment) {
          BlocProvider.of<account.AccountBloc>(event.context).add(
            account.AccountTransferBack(
              booking: event.booking.copyWith(
                fromAccount: event.booking.fromAccount,
                toAccount: event.booking.toAccount,
              ),
              bookedId: 0,
            ),
          );
        }
        final deleteBookingEither = await deleteUseCase.bookingRepository.delete(event.booking.id);
        deleteBookingEither.fold((failure) {
          emit(const Error(message: DELETE_BOOKING_FAILURE));
        }, (_) {
          Navigator.pushNamedAndRemoveUntil(event.context, bottomNavBarRoute, arguments: BottomNavBarArguments(tabIndex: 0), (route) => false);
        });
      } else if (event is DeleteOnlyFutureSerieBookings) {
        double overallSerieAmount = 0.0;
        for (int i = 0; i < event.bookings.length; i++) {
          if ((event.bookings[i].date.isAfter(event.from) && event.bookings[i].date.isBefore(DateTime.now())) ||
              event.bookings[i].date.isAtSameMomentAs(DateTime.now())) {
            overallSerieAmount += event.bookings[i].amount;
          }
        }
        event.bookings[0] = event.bookings[0].copyWith(amount: overallSerieAmount);
        if (event.bookings[0].type == BookingType.expense) {
          BlocProvider.of<account.AccountBloc>(event.context).add(account.AccountDeposit(booking: event.bookings[0], bookedId: 0));
        } else if (event.bookings[0].type == BookingType.income) {
          BlocProvider.of<account.AccountBloc>(event.context).add(account.AccountWithdraw(booking: event.bookings[0], bookedId: 0));
        } else if (event.bookings[0].type == BookingType.transfer || event.bookings[0].type == BookingType.investment) {
          BlocProvider.of<account.AccountBloc>(event.context).add(
            account.AccountTransferBack(
              booking: event.bookings[0].copyWith(
                fromAccount: event.bookings[0].fromAccount,
                toAccount: event.bookings[0].toAccount,
              ),
              bookedId: 0,
            ),
          );
        }
        final deleteBookingEither = await deleteUseCase.bookingRepository.deleteOnlyFutureBookingsInSerie(event.serieId, event.from);
        deleteBookingEither.fold((failure) {
          emit(const Error(message: DELETE_BOOKINGS_FAILURE));
        }, (_) {
          Navigator.pushNamedAndRemoveUntil(event.context, bottomNavBarRoute, arguments: BottomNavBarArguments(tabIndex: 0), (route) => false);
        });
      } else if (event is DeleteAllSerieBookings) {
        double overallSerieAmount = 0.0;
        for (int i = 0; i < event.bookings.length; i++) {
          if (event.bookings[i].date.isBefore(DateTime.now()) || event.bookings[i].date.isAtSameMomentAs(DateTime.now())) {
            overallSerieAmount += event.bookings[i].amount;
          }
        }
        event.bookings[0] = event.bookings[0].copyWith(amount: overallSerieAmount);
        if (event.bookings[0].type == BookingType.expense) {
          BlocProvider.of<account.AccountBloc>(event.context).add(account.AccountDeposit(booking: event.bookings[0], bookedId: 0));
        } else if (event.bookings[0].type == BookingType.income) {
          BlocProvider.of<account.AccountBloc>(event.context).add(account.AccountWithdraw(booking: event.bookings[0], bookedId: 0));
        } else if (event.bookings[0].type == BookingType.transfer || event.bookings[0].type == BookingType.investment) {
          BlocProvider.of<account.AccountBloc>(event.context).add(
            account.AccountTransferBack(
              booking: event.bookings[0].copyWith(
                fromAccount: event.bookings[0].fromAccount,
                toAccount: event.bookings[0].toAccount,
              ),
              bookedId: 0,
            ),
          );
        }
        final deleteBookingEither = await deleteUseCase.bookingRepository.deleteAllBookingsInSerie(event.serieId);
        deleteBookingEither.fold((failure) {
          emit(const Error(message: DELETE_BOOKINGS_FAILURE));
        }, (_) {
          Navigator.pushNamedAndRemoveUntil(event.context, bottomNavBarRoute, arguments: BottomNavBarArguments(tabIndex: 0), (route) => false);
        });
      } else if (event is LoadSortedMonthlyBookings) {
        final loadBookingEither = await loadSortedMonthlyUseCase.bookingRepository.loadSortedMonthly(event.selectedDate);
        loadBookingEither.fold((failure) {
          emit(const Error(message: LOAD_BOOKINGS_FAILURE));
        }, (bookings) {
          emit(Loaded(bookings: bookings));
        });
      } else if (event is LoadAmountTypeMonthlyBookings) {
        final loadBookingEither =
            await loadAmountTypeMonthlyUseCase.bookingRepository.loadMonthlyAmountTypeBookings(event.selectedDate, event.amountType);
        loadBookingEither.fold((failure) {
          emit(const Error(message: LOAD_BOOKINGS_FAILURE));
        }, (bookings) {
          emit(Loaded(bookings: bookings));
        });
      } else if (event is LoadCategorieBookings) {
        final loadCategorieBookingEither = await loadCategorieBookingsUseCase.bookingRepository.loadCategorieBookings(event.categorie);
        loadCategorieBookingEither.fold((failure) {
          emit(const Error(message: LOAD_BOOKINGS_FAILURE));
        }, (bookings) {
          emit(CategorieBookingsLoaded(bookings: bookings));
        });
      } else if (event is LoadPastMonthlyCategorieBookings) {
        final loadPastMonthlyCategorieBookingEither = await loadPastMonthlyCategorieBookingsUseCase.bookingRepository
            .loadPastMonthlyCategorieBookings(event.categorie, event.bookingType, event.date, event.monthNumber);
        loadPastMonthlyCategorieBookingEither.fold((failure) {
          emit(const Error(message: LOAD_BOOKINGS_FAILURE));
        }, (bookings) {
          emit(CategorieBookingsLoaded(bookings: bookings));
        });
      } else if (event is LoadSerieBookings) {
        final loadSerieBookingEither = await loadSerieBookingsUseCase.bookingRepository.loadSerieBookings(event.serieId);
        loadSerieBookingEither.fold((failure) {
          emit(const Error(message: LOAD_BOOKINGS_FAILURE));
        }, (bookings) {
          emit(SerieLoaded(bookings: bookings));
        });
      } else if (event is UpdateBookingsWithCategorie) {
        final updateAllBookingsEither = await updateAllBookingsWithCategorieUseCase.bookingRepository
            .updateAllBookingsWithCategorie(event.oldCategorie, event.newCategorie, event.categorieType);
        updateAllBookingsEither.fold((failure) {
          emit(const Error(message: UPDATE_ALL_BOOKINGS_FAILURE));
        }, (_) {});
      } else if (event is UpdateBookingsWithAccount) {
        final updateAllBookingsEither =
            await updateAllBookingsWithAccountUseCase.bookingRepository.updateAllBookingsWithAccount(event.oldAccount, event.newAccount);
        updateAllBookingsEither.fold((failure) {
          emit(const Error(message: UPDATE_ALL_BOOKINGS_FAILURE));
        }, (_) {});
      } else if (event is HandleAndUpdateNewBookings) {
        final checkNewBookingsEither = await calculateAndUpdateNewBookingsUseCase.bookingRepository.calculateAndUpdateNewBookings();
        checkNewBookingsEither.fold((failure) {
          emit(const Error(message: NEW_BOOKINGS_FAILURE));
        }, (_) {});
      } else if (event is TranslateAllBookings) {
        final translateAllBookingsEither = await translateAllBookingsUseCase.bookingRepository.translate(event.context);
        translateAllBookingsEither.fold((failure) {
          emit(const Error(message: TRANSLATE_BOOKINGS_FAILURE));
        }, (_) {});
      }
    });
  }
}
