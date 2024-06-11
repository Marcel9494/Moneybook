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

class DeleteBooking extends BookingEvent {
  final int bookingId;
  final BuildContext context;

  const DeleteBooking(this.bookingId, this.context);

  @override
  List<Object?> get props => [bookingId, context];
}

class LoadSortedMonthlyBookings extends BookingEvent {
  final DateTime selectedDate;

  const LoadSortedMonthlyBookings(this.selectedDate);

  @override
  List<Object?> get props => [selectedDate];
}
