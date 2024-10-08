import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/core/error/failures.dart';
import 'package:moneybook/features/bookings/domain/value_objects/repetition_type.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/consts/route_consts.dart';
import '../../../../shared/presentation/widgets/arguments/bottom_nav_bar_arguments.dart';
import '../../../accounts/presentation/bloc/account_bloc.dart' as account;
import '../../../categories/domain/value_objects/categorie_type.dart';
import '../../domain/entities/booking.dart';
import '../../domain/usecases/check_for_new_bookings.dart';
import '../../domain/usecases/create.dart';
import '../../domain/usecases/delete.dart';
import '../../domain/usecases/get_new_serie_id.dart';
import '../../domain/usecases/load_categorie_bookings.dart';
import '../../domain/usecases/load_new_bookings.dart';
import '../../domain/usecases/load_serie_bookings.dart';
import '../../domain/usecases/load_sorted_monthly_bookings.dart';
import '../../domain/usecases/update.dart';
import '../../domain/usecases/update_all_bookings_in_serie.dart';
import '../../domain/usecases/update_all_bookings_with_account.dart';
import '../../domain/usecases/update_all_bookings_with_categorie.dart';
import '../../domain/usecases/update_only_future_bookings_in_serie.dart';
import '../../domain/value_objects/booking_type.dart';

part 'booking_event.dart';
part 'booking_state.dart';

const String CREATE_BOOKING_FAILURE = 'Buchung konnte nicht erstellt werden.';
const String UPDATE_BOOKING_FAILURE = 'Buchung konnte nicht bearbeitet werden.';
const String UPDATE_SERIE_BOOKINGS_FAILURE = 'Serienbuchungen konnten nicht bearbeitet werden.';
const String DELETE_BOOKING_FAILURE = 'Buchung konnte nicht gelöscht werden.';
const String LOAD_BOOKINGS_FAILURE = 'Buchungen konnten nicht geladen werden.';
const String UPDATE_ALL_BOOKINGS_FAILURE = 'Buchungen konnten nicht aktualisiert werden.';
const String NEW_BOOKINGS_FAILURE = 'Neue Buchungen konnten nicht abgefragt/aktualisiert werden.';
const String LOAD_NEW_BOOKINGS_FAILURE = 'Neue Buchungen konnten nicht geladen werden.';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final Create createUseCase;
  final Update updateUseCase;
  final Delete deleteUseCase;
  final LoadSortedMonthly loadSortedMonthlyUseCase;
  final LoadAllCategorieBookings loadCategorieBookingsUseCase;
  final LoadNewBookings loadNewBookingsUseCase;
  final LoadAllSerieBookings loadSerieBookingsUseCase;
  final UpdateAllBookingsWithCategorie updateAllBookingsWithCategorieUseCase;
  final UpdateAllBookingsWithAccount updateAllBookingsWithAccountUseCase;
  final UpdateAllBookingsInSerie updateAllBookingsInSerieUseCase;
  final UpdateOnlyFutureBookingsInSerie updateOnlyFutureBookingsInSerieUseCase;
  final CheckForNewBookings checkNewBookingsUseCase;
  final GetNewSerieId getNewSerieIdUseCase;

  BookingBloc(
    this.createUseCase,
    this.updateUseCase,
    this.deleteUseCase,
    this.loadSortedMonthlyUseCase,
    this.loadCategorieBookingsUseCase,
    this.loadSerieBookingsUseCase,
    this.updateAllBookingsWithCategorieUseCase,
    this.updateAllBookingsWithAccountUseCase,
    this.updateAllBookingsInSerieUseCase,
    this.updateOnlyFutureBookingsInSerieUseCase,
    this.checkNewBookingsUseCase,
    this.loadNewBookingsUseCase,
    this.getNewSerieIdUseCase,
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
              DateTime nextDate = DateTime(originalDate.year, originalDate.month + (i + 3), originalDate.day);
              Booking nextBooking = event.booking.copyWith(date: nextDate);
              createSerieBookingEither = await createUseCase.bookingRepository.create(nextBooking);
              bookings.add(nextBooking);
            }
          } else if (event.booking.repetition == RepetitionType.sixMonths) {
            for (int i = 0; i < 2 * serieYears; i++) {
              DateTime originalDate = DateTime.parse(event.booking.date.toString());
              DateTime nextDate = DateTime(originalDate.year, originalDate.month + (i + 6), originalDate.day);
              Booking nextBooking = event.booking.copyWith(date: nextDate);
              createSerieBookingEither = await createUseCase.bookingRepository.create(nextBooking);
              bookings.add(nextBooking);
            }
          } else if (event.booking.repetition == RepetitionType.yearly) {
            for (int i = 0; i < 1 * serieYears; i++) {
              DateTime originalDate = DateTime.parse(event.booking.date.toString());
              DateTime nextDate = DateTime(originalDate.year + i + 1, originalDate.month, originalDate.day);
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
          Navigator.pop(event.context);
          Navigator.popAndPushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarArguments(0));
        });
      } else if (event is UpdateAllSerieBookings) {
        final updateSerieBookingEither =
            await updateAllBookingsInSerieUseCase.bookingRepository.updateAllBookingsInSerie(event.updatedBooking, event.serieBookings);
        updateSerieBookingEither.fold((failure) {
          emit(const Error(message: UPDATE_SERIE_BOOKINGS_FAILURE));
        }, (bookings) {
          emit(SerieUpdated(bookings: bookings));
        });
      } else if (event is UpdateOnlyFutureSerieBookings) {
        final updateSerieBookingEither =
            await updateOnlyFutureBookingsInSerieUseCase.bookingRepository.updateOnlyFutureBookingsInSerie(event.updatedBooking, event.serieBookings);
        updateSerieBookingEither.fold((failure) {
          emit(const Error(message: UPDATE_SERIE_BOOKINGS_FAILURE));
        }, (bookings) {
          emit(SerieUpdated(bookings: bookings));
        });
      } else if (event is DeleteBooking) {
        if (event.booking.type == BookingType.expense) {
          BlocProvider.of<account.AccountBloc>(event.context).add(account.AccountDeposit(event.booking, 0));
        } else if (event.booking.type == BookingType.income) {
          BlocProvider.of<account.AccountBloc>(event.context).add(account.AccountWithdraw(event.booking, 0));
        } else if (event.booking.type == BookingType.transfer || event.booking.type == BookingType.investment) {
          BlocProvider.of<account.AccountBloc>(event.context).add(
            account.AccountTransfer(
              event.booking.copyWith(
                fromAccount: event.booking.toAccount,
                toAccount: event.booking.fromAccount,
              ),
              0,
            ),
          );
        }
        final deleteBookingEither = await deleteUseCase.bookingRepository.delete(event.booking.id);
        deleteBookingEither.fold((failure) {
          emit(const Error(message: DELETE_BOOKING_FAILURE));
        }, (_) {
          Navigator.pop(event.context);
          Navigator.pop(event.context);
          Navigator.popAndPushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarArguments(0));
        });
      } else if (event is LoadSortedMonthlyBookings) {
        final loadBookingEither = await loadSortedMonthlyUseCase.bookingRepository.loadSortedMonthly(event.selectedDate);
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
          emit(Loaded(bookings: bookings));
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
      } else if (event is CheckNewBookings) {
        final checkNewBookingsEither = await checkNewBookingsUseCase.bookingRepository.checkForNewBookings();
        checkNewBookingsEither.fold((failure) {
          emit(const Error(message: NEW_BOOKINGS_FAILURE));
        }, (_) {});
      } else if (event is LoadNewBookingsSinceLastStart) {
        final loadNewBookingsEither = await loadNewBookingsUseCase.bookingRepository.loadNewBookings();
        loadNewBookingsEither.fold((failure) {
          emit(const Error(message: LOAD_NEW_BOOKINGS_FAILURE));
        }, (bookings) {
          emit(NewBookingsLoaded(bookings: bookings));
        });
      }
    });
  }
}
