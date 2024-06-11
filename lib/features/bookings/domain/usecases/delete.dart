import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moneybook/features/bookings/domain/repositories/booking_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class Delete implements UseCase<void, Params> {
  final BookingRepository bookingRepository;

  Delete(this.bookingRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await bookingRepository.delete(params.bookingId);
  }
}

class Params extends Equatable {
  final int bookingId;

  const Params({required this.bookingId});

  @override
  List<Object> get props => [bookingId];
}
