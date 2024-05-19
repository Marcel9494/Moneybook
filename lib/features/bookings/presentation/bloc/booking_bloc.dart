import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/booking.dart';
import '../../domain/usecases/create.dart';

part 'booking_event.dart';
part 'booking_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final Create createUseCase;

  BookingBloc(this.createUseCase) : super(Initial()) {
    on<BookingEvent>((event, emit) async {
      if (event is CreateBooking) {
        final inputEither = await createUseCase.bookingRepository.create(event.booking);
        inputEither.fold((failure) {
          emit(const Error(message: SERVER_FAILURE_MESSAGE));
        }, (booking) {
          emit(Loaded(booking: event.booking));
        });
      }
    });
  }
}
