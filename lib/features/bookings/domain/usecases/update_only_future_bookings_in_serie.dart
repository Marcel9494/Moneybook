import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moneybook/features/bookings/domain/repositories/booking_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/booking.dart';

class UpdateOnlyFutureBookingsInSerie implements UseCase<void, Params> {
  final BookingRepository bookingRepository;

  UpdateOnlyFutureBookingsInSerie(this.bookingRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await bookingRepository.updateOnlyFutureBookingsInSerie(params.updatedBooking, params.serieBookings);
  }
}

class Params extends Equatable {
  final Booking updatedBooking;
  final List<Booking> serieBookings;

  const Params({required this.updatedBooking, required this.serieBookings});

  @override
  List<Object> get props => [updatedBooking, serieBookings];
}
