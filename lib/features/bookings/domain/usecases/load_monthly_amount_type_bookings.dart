import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moneybook/features/bookings/domain/repositories/booking_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../value_objects/amount_type.dart';

class LoadMonthlyAmountTypeBookings implements UseCase<void, Params> {
  final BookingRepository bookingRepository;

  LoadMonthlyAmountTypeBookings(this.bookingRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await bookingRepository.loadMonthlyAmountTypeBookings(params.date, params.amountType);
  }
}

class Params extends Equatable {
  final DateTime date;
  final AmountType amountType;

  const Params({required this.date, required this.amountType});

  @override
  List<Object> get props => [date, amountType];
}
