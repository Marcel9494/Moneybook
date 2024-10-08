import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/booking_repository.dart';

class LoadAllSerieBookings implements UseCase<void, int> {
  final BookingRepository bookingRepository;

  LoadAllSerieBookings(this.bookingRepository);

  @override
  Future<Either<Failure, void>> call(int serieId) async {
    return await bookingRepository.loadSerieBookings(serieId);
  }
}
