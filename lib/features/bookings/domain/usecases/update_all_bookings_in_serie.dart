import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moneybook/features/bookings/domain/repositories/booking_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/booking.dart';

class UpdateAllBookingsInSerie implements UseCase<void, Params> {
  final BookingRepository bookingRepository;

  UpdateAllBookingsInSerie(this.bookingRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await bookingRepository.updateAllBookingsInSerie(params.booking);
  }
}

class Params extends Equatable {
  final Booking booking;

  const Params({required this.booking});

  @override
  List<Object> get props => [booking];
}
