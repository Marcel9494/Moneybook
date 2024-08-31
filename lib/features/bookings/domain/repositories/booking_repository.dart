import 'package:dartz/dartz.dart';
import 'package:moneybook/core/error/failures.dart';
import 'package:moneybook/features/bookings/domain/entities/booking.dart';
import 'package:moneybook/features/categories/domain/value_objects/categorie_type.dart';

abstract class BookingRepository {
  Future<Either<Failure, void>> create(Booking booking);
  Future<Either<Failure, void>> edit(Booking booking);
  Future<Either<Failure, void>> delete(int id);
  Future<Either<Failure, Booking>> load(int id);
  Future<Either<Failure, List<Booking>>> loadSortedMonthly(DateTime selectedDate);
  Future<Either<Failure, List<Booking>>> loadCategorieBookings(String categorie);
  Future<Either<Failure, void>> updateAllBookingsWithCategorie(String oldCategorie, String newCategorie, CategorieType categorieType);
  Future<Either<Failure, void>> updateAllBookingsWithAccount(String oldAccount, String newAccount);
}
