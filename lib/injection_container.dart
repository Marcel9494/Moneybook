import 'package:get_it/get_it.dart';
import 'package:moneybook/features/accounts/domain/usecases/create.dart' as account;
import 'package:moneybook/features/bookings/data/datasources/booking_local_data_source.dart';
import 'package:moneybook/features/bookings/data/repositories/booking_repository_impl.dart';
import 'package:moneybook/features/bookings/domain/repositories/booking_repository.dart';
import 'package:moneybook/features/bookings/domain/usecases/create.dart' as createBooking;
import 'package:moneybook/features/bookings/domain/usecases/delete.dart' as deleteBooking;
import 'package:moneybook/features/bookings/domain/usecases/loadSortedMonthlyBookings.dart';
import 'package:moneybook/features/bookings/presentation/bloc/booking_bloc.dart';

import 'features/accounts/data/datasources/account_local_data_source.dart';
import 'features/accounts/data/datasources/account_remote_data_source.dart';
import 'features/accounts/data/repositories/account_repository_impl.dart';
import 'features/accounts/domain/repositories/account_repository.dart';
import 'features/accounts/presentation/bloc/account_bloc.dart';
import 'features/bookings/data/datasources/booking_remote_data_source.dart';

final sl = GetIt.instance;

void init() {
  //! Features - Booking, Account
  // Bloc
  sl.registerFactory(() => BookingBloc(sl(), sl(), sl()));
  sl.registerFactory(() => AccountBloc(sl()));
  // Use Cases
  sl.registerLazySingleton(() => createBooking.Create(sl()));
  sl.registerLazySingleton(() => deleteBooking.Delete(sl()));
  sl.registerLazySingleton(() => LoadSortedMonthly(sl()));
  sl.registerLazySingleton(() => account.Create(sl()));
  // Repository
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(
      bookingRemoteDataSource: sl(),
      bookingLocalDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(
      accountRemoteDataSource: sl(),
      accountLocalDataSource: sl(),
    ),
  );
  // Data Sources
  sl.registerLazySingleton<BookingLocalDataSource>(() => BookingLocalDataSourceImpl());
  sl.registerLazySingleton<BookingRemoteDataSource>(() => BookingRemoteDataSourceImpl());
  sl.registerLazySingleton<AccountLocalDataSource>(() => AccountLocalDataSourceImpl());
  sl.registerLazySingleton<AccountRemoteDataSource>(() => AccountRemoteDataSourceImpl());
  //! Core
  //sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  //! External
}
