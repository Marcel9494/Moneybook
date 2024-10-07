import 'package:dartz/dartz.dart';
import 'package:moneybook/core/error/failures.dart';
import 'package:moneybook/features/bookings/domain/entities/booking.dart';
import 'package:moneybook/features/categories/domain/value_objects/categorie_type.dart';

abstract class BookingRepository {
  Future<Either<Failure, void>> create(Booking booking);
  Future<Either<Failure, void>> update(Booking booking);
  Future<Either<Failure, void>> delete(int id);
  Future<Either<Failure, Booking>> load(int id);
  Future<Either<Failure, List<Booking>>> loadSortedMonthly(DateTime selectedDate);
  Future<Either<Failure, List<Booking>>> loadCategorieBookings(String categorie);
  Future<Either<Failure, List<Booking>>> loadNewBookings();
  Future<Either<Failure, List<Booking>>> loadSerieBookings(int serieId);
  Future<Either<Failure, void>> updateAllBookingsWithCategorie(String oldCategorie, String newCategorie, CategorieType categorieType);
  Future<Either<Failure, void>> updateAllBookingsWithAccount(String oldAccount, String newAccount);
  Future<Either<Failure, List<Booking>>> updateAllBookingsInSerie(Booking updatedBooking, List<Booking> serieBookings);
  Future<Either<Failure, List<Booking>>> updateOnlyFutureBookingsInSerie(Booking updatedBooking, List<Booking> serieBookings);
  Future<Either<Failure, void>> checkForNewBookings();
  Future<Either<Failure, int>> getNewSerieId();
}
