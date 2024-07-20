import 'package:dartz/dartz.dart';
import 'package:moneybook/features/bookings/domain/repositories/booking_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class LoadAllCategorieBookings implements UseCase<void, String> {
  final BookingRepository bookingRepository;

  LoadAllCategorieBookings(this.bookingRepository);

  @override
  Future<Either<Failure, void>> call(String categorie) async {
    return await bookingRepository.loadCategorieBookings(categorie);
  }
}
