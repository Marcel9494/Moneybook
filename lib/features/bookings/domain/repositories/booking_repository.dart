import 'package:dartz/dartz.dart';
import 'package:moneybook/core/error/failures.dart';
import 'package:moneybook/features/bookings/domain/entities/booking.dart';

abstract class BookingRepository {
  Future<Either<Failure, void>> create(Booking booking);
  Future<Either<Failure, void>> update(Booking booking);
  Future<Either<Failure, void>> delete(int id);
  Future<Either<Failure, Booking>> get(int id);
  Future<Either<Failure, List<Booking>>> getAll();
}