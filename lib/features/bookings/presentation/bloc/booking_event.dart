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

class CreateSerieBooking extends BookingEvent {
  Booking booking;

  CreateSerieBooking(this.booking);

  @override
  List<Object?> get props => [booking];
}

class UpdateBooking extends BookingEvent {
  final Booking booking;
  final BuildContext context;

  const UpdateBooking(this.booking, this.context);

  @override
  List<Object?> get props => [booking, context];
}

class UpdateAllSerieBookings extends BookingEvent {
  final Booking updatedBooking;
  final List<Booking> serieBookings;

  const UpdateAllSerieBookings(this.updatedBooking, this.serieBookings);

  @override
  List<Object?> get props => [updatedBooking, serieBookings];
}

class UpdateOnlyFutureSerieBookings extends BookingEvent {
  final Booking updatedBooking;
  final List<Booking> serieBookings;

  const UpdateOnlyFutureSerieBookings(this.updatedBooking, this.serieBookings);

  @override
  List<Object?> get props => [updatedBooking, serieBookings];
}

class DeleteBooking extends BookingEvent {
  final Booking booking;
  final BuildContext context;

  const DeleteBooking(this.booking, this.context);

  @override
  List<Object?> get props => [booking, context];
}

class LoadSortedMonthlyBookings extends BookingEvent {
  final DateTime selectedDate;

  const LoadSortedMonthlyBookings(this.selectedDate);

  @override
  List<Object?> get props => [selectedDate];
}

class LoadCategorieBookings extends BookingEvent {
  final String categorie;

  const LoadCategorieBookings(this.categorie);

  @override
  List<Object?> get props => [categorie];
}

class LoadSerieBookings extends BookingEvent {
  final int serieId;

  const LoadSerieBookings(this.serieId);

  @override
  List<Object?> get props => [serieId];
}

class UpdateBookingsWithCategorie extends BookingEvent {
  final String oldCategorie;
  final String newCategorie;
  final CategorieType categorieType;

  const UpdateBookingsWithCategorie(this.oldCategorie, this.newCategorie, this.categorieType);

  @override
  List<Object?> get props => [oldCategorie, newCategorie, categorieType];
}

class UpdateBookingsWithAccount extends BookingEvent {
  final String oldAccount;
  final String newAccount;

  const UpdateBookingsWithAccount(this.oldAccount, this.newAccount);

  @override
  List<Object?> get props => [oldAccount, newAccount];
}

class CheckNewBookings extends BookingEvent {
  const CheckNewBookings();

  @override
  List<Object?> get props => [];
}

class LoadNewBookingsSinceLastStart extends BookingEvent {
  const LoadNewBookingsSinceLastStart();

  @override
  List<Object?> get props => [];
}
