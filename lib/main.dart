import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moneybook/features/accounts/presentation/pages/create_account_page.dart';
import 'package:moneybook/features/bookings/presentation/bloc/booking_bloc.dart';
import 'package:moneybook/features/bookings/presentation/pages/booking_list_page.dart';
import 'package:moneybook/features/bookings/presentation/pages/create_booking_page.dart';
import 'package:moneybook/features/bookings/presentation/widgets/page_arguments/edit_booking_page_arguments.dart';
import 'package:moneybook/shared/presentation/widgets/navigation_widget/navigation_widget.dart';

import 'core/consts/route_consts.dart';
import 'core/theme/darkTheme.dart';
import 'features/bookings/presentation/pages/edit_booking_page.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => sl<BookingBloc>(),
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
      home: const BottomNavBar(),
      routes: {
        bottomNavBarRoute: (context) => const BottomNavBar(),
        bookingListRoute: (context) => const BookingListPage(),
        createBookingRoute: (context) => const CreateBookingPage(),
        createAccountRoute: (context) => const CreateAccountPage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
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
