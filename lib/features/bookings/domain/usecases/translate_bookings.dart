import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:moneybook/features/bookings/domain/repositories/booking_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class TranslateBookings implements UseCase<void, Params> {
  final BookingRepository bookingRepository;

  TranslateBookings(this.bookingRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await bookingRepository.translate(params.context);
  }
}

class Params extends Equatable {
  final BuildContext context;

  const Params({required this.context});

  @override
  List<Object> get props => [context];
}
