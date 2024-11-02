part of 'booking_bloc.dart';

sealed class BookingState extends Equatable {
  const BookingState();
}

final class Initial extends BookingState {
  @override
  List<Object> get props => [];
}

final class Loading extends BookingState {
  @override
  List<Object> get props => [];
}

final class Loaded extends BookingState {
  List<Booking> bookings;

  Loaded({required this.bookings});

  @override
  List<Object> get props => [bookings];
}

final class CategorieBookingsLoaded extends BookingState {
  List<Booking> bookings;

  CategorieBookingsLoaded({required this.bookings});

  @override
  List<Object> get props => [bookings];
}

final class SerieLoaded extends BookingState {
  List<Booking> bookings;

  SerieLoaded({required this.bookings});

  @override
  List<Object> get props => [bookings];
}

final class NewBookingsLoaded extends BookingState {
  final List<Booking> bookings;

  const NewBookingsLoaded({required this.bookings});

  @override
  List<Object> get props => [bookings];
}

final class Finished extends BookingState {
  @override
  List<Object> get props => [];
}

final class SerieUpdated extends BookingState {
  List<Booking> bookings;

  SerieUpdated({required this.bookings});

  @override
  List<Object> get props => [bookings];
}

final class SerieFinished extends BookingState {
  final List<Booking> bookings;

  const SerieFinished({required this.bookings});

  @override
  List<Object> get props => [bookings];
}

final class Error extends BookingState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}
