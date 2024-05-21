part of 'booking_bloc.dart';

sealed class BookingEvent extends Equatable {
  const BookingEvent();
}

class CreateBooking extends BookingEvent {
  final Booking booking;

  const CreateBooking(this.booking);

  @override
  List<Object?> get props => [booking];
}
