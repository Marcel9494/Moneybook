import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moneybook/features/bookings/domain/repositories/booking_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteAllBookingsInSerie implements UseCase<void, Params> {
  final BookingRepository bookingRepository;

  DeleteAllBookingsInSerie(this.bookingRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await bookingRepository.deleteAllBookingsInSerie(params.serieId);
  }
}

class Params extends Equatable {
  final int serieId;

  const Params({required this.serieId});

  @override
  List<Object> get props => [serieId];
}
