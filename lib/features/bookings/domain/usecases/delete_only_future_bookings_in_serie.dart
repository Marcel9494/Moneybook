import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moneybook/features/bookings/domain/repositories/booking_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteOnlyFutureBookingsInSerie implements UseCase<void, Params> {
  final BookingRepository bookingRepository;

  DeleteOnlyFutureBookingsInSerie(this.bookingRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await bookingRepository.deleteOnlyFutureBookingsInSerie(params.serieId, params.from);
  }
}

class Params extends Equatable {
  final int serieId;
  final DateTime from;

  const Params({required this.serieId, required this.from});

  @override
  List<Object> get props => [serieId, from];
}
