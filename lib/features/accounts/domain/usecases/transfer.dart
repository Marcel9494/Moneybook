import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../bookings/domain/entities/booking.dart';
import '../repositories/account_repository.dart';

class Transfer implements UseCase<void, Params> {
  final AccountRepository accountRepository;

  Transfer(this.accountRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await accountRepository.transfer(params.booking);
  }
}

class Params extends Equatable {
  final Booking booking;

  const Params({required this.booking});

  @override
  List<Object> get props => [booking];
}
