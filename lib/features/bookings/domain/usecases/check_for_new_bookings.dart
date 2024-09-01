import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/booking_repository.dart';

class CheckForNewBookings implements UseCase<void, void> {
  final BookingRepository bookingRepository;

  CheckForNewBookings(this.bookingRepository);

  @override
  Future<Either<Failure, void>> call([void params]) async {
    return await bookingRepository.checkForNewBookings();
  }
}
