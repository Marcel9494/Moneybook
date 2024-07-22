import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:moneybook/features/bookings/domain/value_objects/repetition_type.dart';
import 'package:moneybook/shared/presentation/widgets/arguments/bottom_nav_bar_arguments.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/consts/route_consts.dart';
import '../../domain/entities/booking.dart';
import '../../domain/usecases/create.dart';
import '../../domain/usecases/createSerie.dart';
import '../../domain/usecases/delete.dart';
import '../../domain/usecases/load_categorie_bookings.dart';
import '../../domain/usecases/load_sorted_monthly_bookings.dart';

part 'booking_event.dart';
part 'booking_state.dart';

const String CREATE_BOOKING_FAILURE = 'Buchung konnte nicht erstellt werden.';
const String EDIT_BOOKING_FAILURE = 'Buchung konnte nicht bearbeitet werden.';
const String DELETE_BOOKING_FAILURE = 'Buchung konnte nicht gelöscht werden.';
const String LOAD_BOOKINGS_FAILURE = 'Buchungen konnten nicht geladen werden.';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final Create createUseCase;
  final CreateSerie createSerieUseCase;
  final Create editUseCase; // TODO von Create auf Edit ändern
  final Delete deleteUseCase;
  final LoadSortedMonthly loadSortedMonthlyUseCase;
  final LoadAllCategorieBookings loadCategorieBookingsUseCase;

  BookingBloc(this.createUseCase, this.createSerieUseCase, this.editUseCase, this.deleteUseCase, this.loadSortedMonthlyUseCase,
      this.loadCategorieBookingsUseCase)
      : super(Initial()) {
    on<BookingEvent>((event, emit) async {
      if (event is CreateBooking) {
        final createBookingEither = await createUseCase.bookingRepository.create(event.booking);
        createBookingEither.fold((failure) {
          emit(const Error(message: CREATE_BOOKING_FAILURE));
        }, (_) {
          emit(Finished());
        });
      } else if (event is CreateSerieBooking) {
        List<Booking> bookings = [];
        var createSerieBookingEither = await createUseCase.bookingRepository.create(event.booking);
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
            DateTime nextDate = DateTime(originalDate.year, originalDate.month + (i + 1), 0);
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
        createSerieBookingEither.fold((failure) {
          emit(const Error(message: CREATE_BOOKING_FAILURE));
        }, (_) {
          emit(SerieFinished(bookings: bookings));
        });
      } else if (event is EditBooking) {
        final editBookingEither = await editUseCase.bookingRepository.edit(event.booking);
        editBookingEither.fold((failure) {
          emit(const Error(message: EDIT_BOOKING_FAILURE));
        }, (_) {
          Navigator.pop(event.context);
          Navigator.popAndPushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarArguments(0));
        });
      } else if (event is DeleteBooking) {
        final deleteBookingEither = await deleteUseCase.bookingRepository.delete(event.bookingId);
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
      }
    });
  }
}
