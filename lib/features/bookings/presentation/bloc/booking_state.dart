part of 'booking_bloc.dart';

sealed class BookingState extends Equatable {
  const BookingState();
}

final class Initial extends BookingState {
  @override
  List<Object> get props => [];
}

final class Finished extends BookingState {
  @override
  List<Object> get props => [];
}

final class Error extends BookingState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}
