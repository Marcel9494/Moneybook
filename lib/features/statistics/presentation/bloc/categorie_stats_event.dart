part of 'categorie_stats_bloc.dart';

sealed class CategorieStatsEvent extends Equatable {
  const CategorieStatsEvent();
}

class CalculateCategorieStats extends CategorieStatsEvent {
  final List<Booking> bookings;
  final BookingType bookingType;
  final AmountType amountType;

  const CalculateCategorieStats(
    this.bookings,
    this.bookingType,
    this.amountType,
  );

  @override
  List<Object?> get props => [bookings, bookingType, amountType];
}
