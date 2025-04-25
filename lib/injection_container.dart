import 'package:get_it/get_it.dart';
import 'package:moneybook/features/accounts/domain/usecases/create.dart' as create_account;
import 'package:moneybook/features/accounts/domain/usecases/delete.dart' as delete_account;
import 'package:moneybook/features/accounts/domain/usecases/edit.dart' as edit_account;
import 'package:moneybook/features/accounts/domain/usecases/load_filtered_accounts.dart';
import 'package:moneybook/features/bookings/data/datasources/booking_local_data_source.dart';
import 'package:moneybook/features/bookings/data/repositories/booking_repository_impl.dart';
import 'package:moneybook/features/bookings/domain/repositories/booking_repository.dart';
import 'package:moneybook/features/bookings/domain/usecases/calculate_and_update_new_bookings.dart';
import 'package:moneybook/features/bookings/domain/usecases/create.dart' as create_booking;
import 'package:moneybook/features/bookings/domain/usecases/delete.dart' as delete_booking;
import 'package:moneybook/features/bookings/domain/usecases/get_new_serie_id.dart';
import 'package:moneybook/features/bookings/domain/usecases/load_past_categorie_bookings.dart';
import 'package:moneybook/features/bookings/domain/usecases/load_sorted_monthly_bookings.dart';
import 'package:moneybook/features/bookings/domain/usecases/update.dart' as edit_booking;
import 'package:moneybook/features/bookings/domain/usecases/update_all_bookings_with_categorie.dart';
import 'package:moneybook/features/budgets/domain/usecases/create.dart' as create_budget;
import 'package:moneybook/features/budgets/domain/usecases/delete.dart' as delete_budget;
import 'package:moneybook/features/budgets/domain/usecases/edit.dart' as edit_budget;
import 'package:moneybook/features/categories/domain/usecases/create.dart' as create_categorie;
import 'package:moneybook/features/categories/domain/usecases/delete.dart' as delete_categorie;
import 'package:moneybook/features/categories/domain/usecases/edit.dart' as edit_categorie;
import 'package:moneybook/features/categories/domain/usecases/get_id.dart' as get_id;
import 'package:moneybook/features/user/domain/usecases/create.dart' as create_user;
import 'package:moneybook/features/user/domain/usecases/getLanguageUseCase.dart';
import 'package:moneybook/shared/data/datasources/shared_local_data_source.dart';
import 'package:moneybook/shared/data/datasources/shared_remote_data_source.dart';
import 'package:moneybook/shared/data/repositories/shared_repository_impl.dart';
import 'package:moneybook/shared/data/usecases/createDb.dart';
import 'package:moneybook/shared/data/usecases/createStartDbValues.dart';
import 'package:moneybook/shared/domain/repositories/shared_repository.dart';
import 'package:moneybook/shared/presentation/bloc/shared_bloc.dart';

import 'features/accounts/data/datasources/account_local_data_source.dart';
import 'features/accounts/data/datasources/account_remote_data_source.dart';
import 'features/accounts/data/repositories/account_repository_impl.dart';
import 'features/accounts/domain/repositories/account_repository.dart';
import 'features/accounts/domain/usecases/check_account_name.dart';
import 'features/accounts/domain/usecases/load_all_accounts.dart' as load_all_accounts;
import 'features/accounts/presentation/bloc/account_bloc.dart';
import 'features/bookings/data/datasources/booking_remote_data_source.dart';
import 'features/bookings/domain/usecases/delete_all_bookings_in_serie.dart';
import 'features/bookings/domain/usecases/delete_only_future_bookings_in_serie.dart';
import 'features/bookings/domain/usecases/load_categorie_bookings.dart';
import 'features/bookings/domain/usecases/load_monthly_amount_type_bookings.dart';
import 'features/bookings/domain/usecases/load_serie_bookings.dart';
import 'features/bookings/domain/usecases/translate_bookings.dart';
import 'features/bookings/domain/usecases/update_all_bookings_in_serie.dart';
import 'features/bookings/domain/usecases/update_all_bookings_with_account.dart';
import 'features/bookings/domain/usecases/update_only_future_bookings_in_serie.dart';
import 'features/bookings/presentation/bloc/booking_bloc.dart';
import 'features/budgets/data/datasources/budget_local_data_source.dart';
import 'features/budgets/data/datasources/budget_remote_data_source.dart';
import 'features/budgets/data/repositories/budget_repository_impl.dart';
import 'features/budgets/domain/repositories/budget_repository.dart';
import 'features/budgets/domain/usecases/load_monthly.dart';
import 'features/budgets/domain/usecases/update_all_budgets_with_categorie.dart';
import 'features/budgets/presentation/bloc/budget_bloc.dart';
import 'features/categories/data/datasources/categorie_local_data_source.dart';
import 'features/categories/data/datasources/categorie_remote_data_source.dart';
import 'features/categories/data/repositories/categorie_repository_impl.dart';
import 'features/categories/domain/repositories/categorie_repository.dart';
import 'features/categories/domain/usecases/check_categorie_name.dart';
import 'features/categories/domain/usecases/load_all.dart' as load_all_categories;
import 'features/categories/presentation/bloc/categorie_bloc.dart';
import 'features/statistics/presentation/bloc/categorie_stats_bloc.dart';
import 'features/user/data/datasources/user_local_data_source.dart';
import 'features/user/data/datasources/user_remote_data_source.dart';
import 'features/user/data/repositories/user_repository_impl.dart';
import 'features/user/domain/repositories/user_repository.dart';
import 'features/user/domain/usecases/checkFirstStart.dart';
import 'features/user/domain/usecases/updateLanguageUseCase.dart';
import 'features/user/domain/usecases/update_currency_use_case.dart';
import 'features/user/presentation/bloc/user_bloc.dart';

final sl = GetIt.instance;

void init() {
  // Features
  // Bloc
  sl.registerFactory(() => BookingBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory(() => CategorieBloc(sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory(() => AccountBloc(sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory(() => BudgetBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory(() => UserBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory(() => SharedBloc(sl(), sl()));
  sl.registerFactory(() => CategorieStatsBloc());
  // Use Cases
  // Shared
  sl.registerLazySingleton(() => CreateDb(sl()));
  sl.registerLazySingleton(() => CreateStartDbValues(sl()));

  // Bookings
  sl.registerLazySingleton(() => create_booking.Create(sl()));
  sl.registerLazySingleton(() => edit_booking.Update(sl()));
  sl.registerLazySingleton(() => delete_booking.Delete(sl()));
  sl.registerLazySingleton(() => DeleteAllBookingsInSerie(sl()));
  sl.registerLazySingleton(() => DeleteOnlyFutureBookingsInSerie(sl()));
  sl.registerLazySingleton(() => LoadSortedMonthly(sl()));
  sl.registerLazySingleton(() => LoadMonthlyAmountTypeBookings(sl()));
  sl.registerLazySingleton(() => LoadAllCategorieBookings(sl()));
  sl.registerLazySingleton(() => LoadPastCategorieBookings(sl()));
  sl.registerLazySingleton(() => LoadAllSerieBookings(sl()));
  sl.registerLazySingleton(() => UpdateAllBookingsWithCategorie(sl()));
  sl.registerLazySingleton(() => UpdateAllBookingsWithAccount(sl()));
  sl.registerLazySingleton(() => UpdateAllBookingsInSerie(sl()));
  sl.registerLazySingleton(() => UpdateOnlyFutureBookingsInSerie(sl()));
  sl.registerLazySingleton(() => CalculateAndUpdateNewBookings(sl()));
  sl.registerLazySingleton(() => GetNewSerieId(sl()));
  sl.registerLazySingleton(() => TranslateBookings(sl()));

  // Categories
  sl.registerLazySingleton(() => create_categorie.Create(sl()));
  sl.registerLazySingleton(() => edit_categorie.Edit(sl()));
  sl.registerLazySingleton(() => delete_categorie.Delete(sl()));
  sl.registerLazySingleton(() => get_id.GetId(sl()));
  sl.registerLazySingleton(() => load_all_categories.LoadAll(sl()));
  sl.registerLazySingleton(() => CheckCategorieName(sl()));

  // Accounts
  sl.registerLazySingleton(() => create_account.Create(sl()));
  sl.registerLazySingleton(() => edit_account.Edit(sl()));
  sl.registerLazySingleton(() => delete_account.Delete(sl()));
  sl.registerLazySingleton(() => load_all_accounts.LoadAllAccounts(sl()));
  sl.registerLazySingleton(() => LoadFilteredAccounts(sl()));
  sl.registerLazySingleton(() => CheckAccountName(sl()));

  // Budgets
  sl.registerLazySingleton(() => create_budget.Create(sl()));
  sl.registerLazySingleton(() => edit_budget.Edit(sl()));
  sl.registerLazySingleton(() => delete_budget.Delete(sl()));
  sl.registerLazySingleton(() => LoadMonthly(sl(), sl()));
  sl.registerLazySingleton(() => UpdateAllBudgetsWithCategorie(sl()));

  // User
  sl.registerLazySingleton(() => create_user.Create(sl()));
  sl.registerLazySingleton(() => FirstStart(sl()));
  sl.registerLazySingleton(() => UpdateLanguageUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCurrencyUseCase(sl()));
  sl.registerLazySingleton(() => GetLanguageUseCase(sl()));

  // Repository
  sl.registerLazySingleton<SharedRepository>(
    () => SharedRepositoryImpl(
      sharedRemoteDataSource: sl(),
      sharedLocalDataSource: sl(),
    ),
  );
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
  sl.registerLazySingleton<CategorieRepository>(
    () => CategorieRepositoryImpl(
      categorieRemoteDataSource: sl(),
      categorieLocalDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<BudgetRepository>(
    () => BudgetRepositoryImpl(
      budgetRemoteDataSource: sl(),
      budgetLocalDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      userRemoteDataSource: sl(),
      userLocalDataSource: sl(),
    ),
  );
  // Data Sources
  sl.registerLazySingleton<SharedLocalDataSource>(() => SharedLocalDataSourceImpl());
  sl.registerLazySingleton<SharedRemoteDataSource>(() => SharedRemoteDataSourceImpl());
  sl.registerLazySingleton<BookingLocalDataSource>(() => BookingLocalDataSourceImpl());
  sl.registerLazySingleton<BookingRemoteDataSource>(() => BookingRemoteDataSourceImpl());
  sl.registerLazySingleton<AccountLocalDataSource>(() => AccountLocalDataSourceImpl());
  sl.registerLazySingleton<AccountRemoteDataSource>(() => AccountRemoteDataSourceImpl());
  sl.registerLazySingleton<CategorieLocalDataSource>(() => CategorieLocalDataSourceImpl());
  sl.registerLazySingleton<CategorieRemoteDataSource>(() => CategorieRemoteDataSourceImpl());
  sl.registerLazySingleton<BudgetLocalDataSource>(() => BudgetLocalDataSourceImpl());
  sl.registerLazySingleton<BudgetRemoteDataSource>(() => BudgetRemoteDataSourceImpl());
  sl.registerLazySingleton<UserLocalDataSource>(() => UserLocalDataSourceImpl());
  sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl());
  //! Core

  //! External
}
