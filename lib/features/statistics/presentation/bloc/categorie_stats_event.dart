part of 'categorie_stats_bloc.dart';

sealed class CategorieStatsEvent extends Equatable {
  const CategorieStatsEvent();
}

class CalculateCategorieStats extends CategorieStatsEvent {
  final List<Booking> bookings;
  final BookingType bookingType;

  const CalculateCategorieStats(this.bookings, this.bookingType);

  @override
  List<Object?> get props => [bookings, bookingType];
}
