import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/consts/route_consts.dart';
import '../../domain/entities/booking.dart';
import '../../domain/usecases/create.dart';
import '../../domain/usecases/delete.dart';
import '../../domain/usecases/loadSortedMonthlyBookings.dart';

part 'booking_event.dart';
part 'booking_state.dart';

const String CREATE_BOOKING_FAILURE = 'Buchung konnte nicht erstellt werden.';
const String EDIT_BOOKING_FAILURE = 'Buchung konnte nicht bearbeitet werden.';
const String DELETE_BOOKING_FAILURE = 'Buchung konnte nicht gelöscht werden.';
const String LOAD_BOOKINGS_FAILURE = 'Buchungen konnten nicht geladen werden.';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final Create createUseCase;
  final Create editUseCase;
  final Delete deleteUseCase;
  final LoadSortedMonthly loadSortedMonthlyUseCase;

  BookingBloc(this.createUseCase, this.editUseCase, this.deleteUseCase, this.loadSortedMonthlyUseCase) : super(Initial()) {
    on<BookingEvent>((event, emit) async {
      if (event is CreateBooking) {
        final createBookingEither = await createUseCase.bookingRepository.create(event.booking);
        createBookingEither.fold((failure) {
          emit(const Error(message: CREATE_BOOKING_FAILURE));
        }, (_) {
          emit(Finished());
        });
      } else if (event is EditBooking) {
        final editBookingEither = await editUseCase.bookingRepository.edit(event.booking);
        editBookingEither.fold((failure) {
          emit(const Error(message: EDIT_BOOKING_FAILURE));
        }, (_) {
          Navigator.pop(event.context);
          Navigator.popAndPushNamed(event.context, bottomNavBarRoute);
        });
      } else if (event is DeleteBooking) {
        final deleteBookingEither = await deleteUseCase.bookingRepository.delete(event.bookingId);
        deleteBookingEither.fold((failure) {
          emit(const Error(message: DELETE_BOOKING_FAILURE));
        }, (_) {
          Navigator.pop(event.context);
          Navigator.popAndPushNamed(event.context, bottomNavBarRoute);
        });
      } else if (event is LoadSortedMonthlyBookings) {
        final loadBookingEither = await loadSortedMonthlyUseCase.bookingRepository.loadSortedMonthly(event.selectedDate);
        loadBookingEither.fold((failure) {
          emit(const Error(message: LOAD_BOOKINGS_FAILURE));
        }, (bookings) {
          emit(Loaded(booking: bookings));
        });
      }
    });
  }
}
