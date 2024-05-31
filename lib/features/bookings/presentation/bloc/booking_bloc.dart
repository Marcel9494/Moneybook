import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/booking.dart';
import '../../domain/usecases/create.dart';
import '../../domain/usecases/loadSortedMonthlyBookings.dart';

part 'booking_event.dart';
part 'booking_state.dart';

const String CREATE_BOOKING_FAILURE = 'Buchung konnte nicht erstellt werden.';
const String LOAD_BOOKINGS_FAILURE = 'Buchungen konnten nicht geladen werden.';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final Create createUseCase;
  final LoadSortedMonthly loadSortedMonthlyUseCase;

  BookingBloc(this.createUseCase, this.loadSortedMonthlyUseCase) : super(Initial()) {
    on<BookingEvent>((event, emit) async {
      if (event is CreateBooking) {
        final createBookingEither = await createUseCase.bookingRepository.create(event.booking);
        createBookingEither.fold((failure) {
          emit(const Error(message: CREATE_BOOKING_FAILURE));
        }, (_) {
          emit(Finished());
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
