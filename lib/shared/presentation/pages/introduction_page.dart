import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../../core/consts/route_consts.dart';
import '../../../features/bookings/presentation/bloc/booking_bloc.dart';
import '../../../features/user/domain/entities/user.dart';
import '../../../features/user/presentation/bloc/user_bloc.dart';
import '../bloc/shared_bloc.dart';
import '../widgets/arguments/bottom_nav_bar_arguments.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  void _endOfInstruction() {
    BlocProvider.of<SharedBloc>(context).add(const CreateStartDatabaseValues());
    BlocProvider.of<UserBloc>(context).add(
      CreateUser(
        user: User(
          id: 0,
          firstStart: false,
          lastStart: DateTime.now(),
          language: 'De-de',
          localDb: true,
        ),
      ),
    );
    Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarArguments(0));
  }

  void _calculateNewBookings() {
    // TODO Funktion implementieren die alle Buchungen mit isBooked = false & date <= DateTime.now() zurückgibt (z.B. loadNewBookings)
    // TODO Anschließend neuen Kontostand berechnen siehe: create_booking_page.dart mit Serienbuchungen
    // TODO ebenfalls mit BlocConsumer arbeiten.
    /*if (_bookingType == BookingType.expense) {
      BlocProvider.of<AccountBloc>(context).add(AccountWithdraw(newBooking));
    } else if (_bookingType == BookingType.income) {
      BlocProvider.of<AccountBloc>(context).add(AccountDeposit(newBooking));
    } else if (_bookingType == BookingType.transfer || _bookingType == BookingType.investment) {
      BlocProvider.of<AccountBloc>(context).add(AccountTransfer(newBooking, false));
    }*/
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SharedBloc>(context).add(const CreateDatabase());
    _calculateNewBookings();
    BlocProvider.of<BookingBloc>(context).add(const CheckNewBookings());
    BlocProvider.of<UserBloc>(context).add(CheckFirstStart(context: context));
    return IntroductionScreen(
      pages: [
        PageViewModel(
          titleWidget: const Padding(
            padding: EdgeInsets.only(top: 48.0),
            child: Text(
              'Einnahmen, Ausgaben & Investitionen',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
          ),
          bodyWidget: const Text(
            'Behalte alle deine Einnahmen, Ausgaben & Investitionen im Blick.',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          image: Image.asset('assets/animations/introduction_screen_animation_1.gif'),
        ),
        PageViewModel(
          titleWidget: const Padding(
            padding: EdgeInsets.only(top: 48.0),
            child: Text(
              'Budgets',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
          ),
          bodyWidget: const Text(
            'Setze dir feste monatliche Budgets und behalte diese immer im Überblick.',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          image: Image.asset('assets/animations/introduction_screen_animation_1.gif'),
        ),
        PageViewModel(
          titleWidget: const Padding(
            padding: EdgeInsets.only(top: 48.0),
            child: Text(
              'Konten',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
          ),
          bodyWidget: const Text(
            'Behalte alle deine Konten und Investments im Blick.',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          image: Image.asset('assets/animations/introduction_screen_animation_1.gif'),
        ),
        PageViewModel(
          titleWidget: const Padding(
            padding: EdgeInsets.only(top: 48.0),
            child: Text(
              'Updates',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
          ),
          bodyWidget: const Text(
            'Die App wird stetig weiter entwickelt und verbessert.\nFreue dich auf viele weitere Features.',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          image: Image.asset('assets/animations/introduction_screen_animation_1.gif'),
        ),
      ],
      showSkipButton: true,
      skip: const Text('Überspringen', style: TextStyle(color: Colors.white)),
      next: const Text('Weiter'),
      done: const Text('Fertig', style: TextStyle(fontWeight: FontWeight.w700)),
      onDone: () {
        _endOfInstruction();
      },
      onSkip: () {
        _endOfInstruction();
      },
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Colors.cyanAccent,
        color: Colors.white70,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
    );
  }
}
