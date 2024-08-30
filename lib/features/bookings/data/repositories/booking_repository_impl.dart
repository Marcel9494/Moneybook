import 'package:dartz/dartz.dart';
import 'package:moneybook/core/error/exceptions.dart';
import 'package:moneybook/core/error/failures.dart';
import 'package:moneybook/features/bookings/data/datasources/booking_remote_data_source.dart';
import 'package:moneybook/features/bookings/domain/entities/booking.dart';
import 'package:moneybook/features/bookings/domain/repositories/booking_repository.dart';

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
  Future<Either<Failure, void>> edit(Booking booking) async {
    try {
      return Right(await bookingLocalDataSource.edit(booking));
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
    // TODO: implement get
    throw UnimplementedError();
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
  Future<Either<Failure, void>> updateAllBookingsWithCategorie(String oldCategorie, String newCategorie) async {
    try {
      return Right(await bookingLocalDataSource.updateAllBookingsWithCategorie(oldCategorie, newCategorie));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
