import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:moneybook/core/error/exceptions.dart';
import 'package:moneybook/core/error/failures.dart';
import 'package:moneybook/features/bookings/data/datasources/booking_remote_data_source.dart';
import 'package:moneybook/features/bookings/domain/entities/booking.dart';
import 'package:moneybook/features/bookings/domain/repositories/booking_repository.dart';
import 'package:moneybook/features/bookings/domain/value_objects/amount_type.dart';
import 'package:moneybook/features/categories/domain/value_objects/categorie_type.dart';

import '../../domain/value_objects/booking_type.dart';
import '../datasources/booking_local_data_source.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource bookingRemoteDataSource;
  final BookingLocalDataSource bookingLocalDataSource;

  BookingRepositoryImpl({
    required this.bookingRemoteDataSource,
    required this.bookingLocalDataSource,
  });

  @override
  Future<Either<Failure, void>> create(Booking booking) async {
    try {
      return Right(await bookingLocalDataSource.create(booking));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> update(Booking booking) async {
    try {
      return Right(await bookingLocalDataSource.update(booking));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> delete(int id) async {
    try {
      return Right(await bookingLocalDataSource.delete(id));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Booking>> load(int id) async {
    try {
      return Right(await bookingLocalDataSource.load(id));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> loadSortedMonthly(DateTime selectedDate) async {
    try {
      return Right(await bookingLocalDataSource.loadSortedMonthly(selectedDate));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> loadCategorieBookings(String categorie) async {
    try {
      return Right(await bookingLocalDataSource.loadCategorieBookings(categorie));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateAllBookingsWithCategorie(String oldCategorie, String newCategorie, CategorieType categorieType) async {
    try {
      return Right(await bookingLocalDataSource.updateAllBookingsWithCategorie(oldCategorie, newCategorie, categorieType));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateAllBookingsWithAccount(String oldAccount, String newAccount) async {
    try {
      return Right(await bookingLocalDataSource.updateAllBookingsWithAccount(oldAccount, newAccount));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> updateAllBookingsInSerie(Booking updatedBooking, List<Booking> serieBookings) async {
    try {
      return Right(await bookingLocalDataSource.updateAllBookingsInSerie(updatedBooking, serieBookings));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> updateOnlyFutureBookingsInSerie(Booking updatedBooking, List<Booking> serieBookings) async {
    try {
      return Right(await bookingLocalDataSource.updateOnlyFutureBookingsInSerie(updatedBooking, serieBookings));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> calculateAndUpdateNewBookings() async {
    try {
      return Right(await bookingLocalDataSource.calculateAndUpdateNewBookings());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> loadSerieBookings(int serieId) async {
    try {
      return Right(await bookingLocalDataSource.loadSerieBookings(serieId));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getNewSerieId() async {
    try {
      return Right(await bookingLocalDataSource.getNewSerieId());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllBookingsInSerie(int serieId) async {
    try {
      return Right(await bookingLocalDataSource.deleteAllBookingsInSerie(serieId));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteOnlyFutureBookingsInSerie(int serieId, DateTime from) async {
    try {
      return Right(await bookingLocalDataSource.deleteOnlyFutureBookingsInSerie(serieId, from));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> loadPastMonthlyCategorieBookings(
      String categorie, BookingType bookingType, DateTime date, int monthNumber) async {
    try {
      return Right(await bookingLocalDataSource.loadPastMonthlyCategorieBookings(categorie, bookingType, date, monthNumber));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> loadMonthlyAmountTypeBookings(DateTime selectedDate, AmountType amountType) async {
    try {
      return Right(await bookingLocalDataSource.loadMonthlyAmountTypeBookings(selectedDate, amountType));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> translate(BuildContext context) async {
    try {
      return Right(await bookingLocalDataSource.translate(context));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
