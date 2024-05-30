import 'package:dartz/dartz.dart';
import 'package:moneybook/features/bookings/domain/repositories/booking_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class LoadMonthly implements UseCase<void, DateTime> {
  final BookingRepository bookingRepository;

  LoadMonthly(this.bookingRepository);

  @override
  Future<Either<Failure, void>> call(DateTime selectedDate) async {
    return await bookingRepository.loadMonthly(selectedDate);
  }
}
