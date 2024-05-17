import 'package:dartz/dartz.dart';
import 'package:moneybook/features/bookings/domain/repositories/booking_repository.dart';

import '../../../../core/error/failures.dart';
import '../entities/booking.dart';

class Create {
  final BookingRepository bookingRepository;

  Create(this.bookingRepository);

  Future<Either<Failure, void>> execute({required Booking booking}) async {
    return await bookingRepository.create(booking);
  }
}
