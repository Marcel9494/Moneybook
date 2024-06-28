import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moneybook/features/accounts/presentation/pages/account_list_page.dart';
import 'package:moneybook/features/accounts/presentation/pages/create_account_page.dart';
import 'package:moneybook/features/bookings/presentation/bloc/booking_bloc.dart';
import 'package:moneybook/features/bookings/presentation/pages/booking_list_page.dart';
import 'package:moneybook/features/bookings/presentation/pages/create_booking_page.dart';
import 'package:moneybook/features/bookings/presentation/widgets/page_arguments/edit_booking_page_arguments.dart';
import 'package:moneybook/features/categories/presentation/pages/categorie_list_page.dart';
import 'package:moneybook/shared/presentation/widgets/arguments/bottom_nav_bar_arguments.dart';
import 'package:moneybook/shared/presentation/widgets/navigation_widgets/navigation_widget.dart';

import 'core/consts/route_consts.dart';
import 'core/theme/darkTheme.dart';
import 'features/accounts/presentation/bloc/account_bloc.dart';
import 'features/bookings/presentation/pages/edit_booking_page.dart';
import 'features/categories/presentation/bloc/categorie_bloc.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => sl<BookingBloc>(),
    ),
    BlocProvider(
      create: (context) => sl<AccountBloc>(),
    ),
    BlocProvider(
      create: (context) => sl<CategorieBloc>(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      home: const BottomNavBar(tabIndex: 0),
      routes: {
        bookingListRoute: (context) => const BookingListPage(),
        accountListRoute: (context) => const AccountListPage(),
        categorieListRoute: (context) => const CategorieListPage(),
        createBookingRoute: (context) => const CreateBookingPage(),
        createAccountRoute: (context) => const CreateAccountPage(),
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
          case editBookingRoute:
            final args = settings.arguments as EditBookingPageArguments;
            return MaterialPageRoute<String>(
              builder: (BuildContext context) => EditBookingPage(
                booking: args.booking,
              ),
              settings: settings,
            );
        }
        return null;
      },
    );
  }
}
