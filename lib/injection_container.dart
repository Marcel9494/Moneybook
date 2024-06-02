import 'package:get_it/get_it.dart';
import 'package:moneybook/features/bookings/data/datasources/booking_local_data_source.dart';
import 'package:moneybook/features/bookings/data/repositories/booking_repository_impl.dart';
import 'package:moneybook/features/bookings/domain/repositories/booking_repository.dart';
import 'package:moneybook/features/bookings/domain/usecases/create.dart';
import 'package:moneybook/features/bookings/domain/usecases/loadSortedMonthlyBookings.dart';
import 'package:moneybook/features/bookings/presentation/bloc/booking_bloc.dart';

import 'features/accounts/presentation/bloc/account_bloc.dart';
import 'features/bookings/data/datasources/booking_remote_data_source.dart';

final sl = GetIt.instance;

void init() {
  //! Features - Booking
  // Bloc
  sl.registerFactory(() => BookingBloc(sl(), sl()));
  sl.registerFactory(() => AccountBloc());
  // Use Cases
  sl.registerLazySingleton(() => Create(sl()));
  sl.registerLazySingleton(() => LoadSortedMonthly(sl()));
  // Repository
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(
      bookingRemoteDataSource: sl(),
      bookingLocalDataSource: sl(),
      //networkInfo: sl(),
    ),
  );
  // Data Sources
  sl.registerLazySingleton<BookingLocalDataSource>(() => BookingLocalDataSourceImpl());
  sl.registerLazySingleton<BookingRemoteDataSource>(() => BookingRemoteDataSourceImpl());
  //! Core
  //sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  //! External
}
