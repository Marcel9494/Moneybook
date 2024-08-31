import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moneybook/features/bookings/domain/repositories/booking_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class UpdateAllBookingsWithAccount implements UseCase<void, Params> {
  final BookingRepository bookingRepository;

  UpdateAllBookingsWithAccount(this.bookingRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await bookingRepository.updateAllBookingsWithAccount(params.oldAccount, params.newAccount);
  }
}

class Params extends Equatable {
  final String oldAccount;
  final String newAccount;

  const Params({required this.oldAccount, required this.newAccount});

  @override
  List<Object> get props => [oldAccount, newAccount];
}
