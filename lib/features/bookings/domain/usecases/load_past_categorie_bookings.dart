import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moneybook/features/bookings/domain/repositories/booking_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class LoadPastCategorieBookings implements UseCase<void, Params> {
  final BookingRepository bookingRepository;

  LoadPastCategorieBookings(this.bookingRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await bookingRepository.loadPastMonthlyCategorieBookings(params.categorie, params.date, params.monthNumber);
  }
}

class Params extends Equatable {
  final String categorie;
  final DateTime date;
  final int monthNumber;

  const Params({required this.categorie, required this.date, required this.monthNumber});

  @override
  List<Object> get props => [categorie, date, monthNumber];
}
