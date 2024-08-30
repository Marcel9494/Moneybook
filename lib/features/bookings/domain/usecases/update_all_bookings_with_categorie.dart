import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moneybook/features/bookings/domain/repositories/booking_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class UpdateAllBookingsWithCategorie implements UseCase<void, Params> {
  final BookingRepository bookingRepository;

  UpdateAllBookingsWithCategorie(this.bookingRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await bookingRepository.updateAllBookingsWithCategorie(params.oldCategorie, params.newCategorie);
  }
}

class Params extends Equatable {
  final String oldCategorie;
  final String newCategorie;

  const Params({required this.oldCategorie, required this.newCategorie});

  @override
  List<Object> get props => [oldCategorie, newCategorie];
}
