import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moneybook/features/accounts/presentation/pages/account_list_page.dart';
import 'package:moneybook/features/accounts/presentation/pages/create_account_page.dart';
import 'package:moneybook/features/bookings/presentation/bloc/booking_bloc.dart';
import 'package:moneybook/features/bookings/presentation/pages/booking_list_page.dart';
import 'package:moneybook/features/bookings/presentation/pages/create_booking_page.dart';
import 'package:moneybook/features/bookings/presentation/widgets/page_arguments/edit_booking_page_arguments.dart';
import 'package:moneybook/features/categories/presentation/pages/categorie_list_page.dart';
import 'package:moneybook/shared/presentation/bloc/shared_bloc.dart';
import 'package:moneybook/shared/presentation/pages/introduction_page.dart';
import 'package:moneybook/shared/presentation/widgets/arguments/bottom_nav_bar_arguments.dart';
import 'package:moneybook/shared/presentation/widgets/navigation_widgets/navigation_widget.dart';

import 'core/consts/route_consts.dart';
import 'core/theme/darkTheme.dart';
import 'features/accounts/presentation/bloc/account_bloc.dart';
import 'features/accounts/presentation/pages/edit_account_page.dart';
import 'features/accounts/presentation/widgets/page_arguments/edit_account_page_arguments.dart';
import 'features/bookings/presentation/pages/edit_booking_page.dart';
import 'features/budgets/presentation/bloc/budget_bloc.dart';
import 'features/budgets/presentation/pages/create_budget_page.dart';
import 'features/budgets/presentation/pages/edit_budget_page.dart';
import 'features/budgets/presentation/widgets/page_arguments/edit_budget_page_arguments.dart';
import 'features/categories/presentation/bloc/categorie_bloc.dart';
import 'features/statistics/presentation/bloc/categorie_stats_bloc.dart';
import 'features/user/presentation/bloc/user_bloc.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';
import 'shared/presentation/widgets/arguments/selected_date_page_arguments.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => sl<SharedBloc>(),
    ),
    BlocProvider(
      create: (context) => sl<BookingBloc>(),
    ),
    BlocProvider(
      create: (context) => sl<AccountBloc>(),
    ),
    BlocProvider(
      create: (context) => sl<CategorieBloc>(),
    ),
    BlocProvider(
      create: (context) => sl<CategorieStatsBloc>(),
    ),
    BlocProvider(
      create: (context) => sl<BudgetBloc>(),
    ),
    BlocProvider(
      create: (context) => sl<UserBloc>(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  void getStartPage(BuildContext context) {
    BlocProvider.of<SharedBloc>(context).add(DatabaseExists(context: context));
    /*return BlocBuilder<SharedBloc, SharedState>(
      builder: (context, state) {
        if (state is Exists) {
          if (state.exists) {
            return const BottomNavBar(tabIndex: 0);
          }
          return const IntroductionPage();
        }
        return const SizedBox();
      },
    );*/
  }

  const MyApp({super.key});

  @override
  MaterialApp build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Moneybook',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: darkTheme,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('de', 'DE'),
      ],
      home: const IntroductionPage(),
      //home: const BottomNavBar(tabIndex: 0),
      routes: {
        accountListRoute: (context) => const AccountListPage(),
        categorieListRoute: (context) => const CategorieListPage(),
        createBookingRoute: (context) => const CreateBookingPage(),
        createAccountRoute: (context) => const CreateAccountPage(),
        createBudgetRoute: (context) => const CreateBudgetPage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case bottomNavBarRoute:
            final args = settings.arguments as BottomNavBarArguments;
            return MaterialPageRoute<String>(
              builder: (BuildContext context) => BottomNavBar(
                tabIndex: args.tabIndex,
              ),
              settings: settings,
            );
          case bookingListRoute:
            final args = settings.arguments as SelectedDatePageArguments;
            return MaterialPageRoute<String>(
              builder: (BuildContext context) => BookingListPage(
                selectedDate: args.selectedDate,
              ),
              settings: settings,
            );
          case editBookingRoute:
            final args = settings.arguments as EditBookingPageArguments;
            return MaterialPageRoute<String>(
              builder: (BuildContext context) => EditBookingPage(
                booking: args.booking,
                editMode: args.editMode,
              ),
              settings: settings,
            );
          case editAccountRoute:
            final args = settings.arguments as EditAccountPageArguments;
            return MaterialPageRoute<String>(
              builder: (BuildContext context) => EditAccountPage(
                account: args.account,
              ),
              settings: settings,
            );
          case editBudgetRoute:
            final args = settings.arguments as EditBudgetPageArguments;
            return MaterialPageRoute<String>(
              builder: (BuildContext context) => EditBudgetPage(
                budget: args.budget,
                serieMode: args.serieMode,
              ),
              settings: settings,
            );
        }
        return null;
      },
    );
  }
}
