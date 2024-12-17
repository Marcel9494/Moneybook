import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:moneybook/core/consts/common_consts.dart';

import '../../../core/consts/route_consts.dart';
import '../../../features/accounts/presentation/bloc/account_bloc.dart';
import '../../../features/bookings/domain/value_objects/booking_type.dart';
import '../../../features/bookings/presentation/bloc/booking_bloc.dart' as booking;
import '../../../features/user/domain/entities/user.dart';
import '../../../features/user/presentation/bloc/user_bloc.dart' as user;
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
    BlocProvider.of<user.UserBloc>(context).add(
      user.CreateUser(
        user: User(
          id: 0,
          firstStart: false,
          lastStart: DateTime.now(),
          language: locale,
          localDb: true,
        ),
      ),
    );
    Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarArguments(tabIndex: 0));
  }

  void _checkStartConditions() {
    BlocProvider.of<SharedBloc>(context).add(const CreateDatabase());
    BlocProvider.of<booking.BookingBloc>(context).add(const booking.LoadNewBookingsSinceLastStart());
    BlocProvider.of<booking.BookingBloc>(context).add(const booking.CheckNewBookings());
    BlocProvider.of<user.UserBloc>(context).add(user.CheckFirstStart(context: context));
  }

  @override
  Widget build(BuildContext context) {
    _checkStartConditions();
    return BlocConsumer<user.UserBloc, user.UserState>(
      listener: (context, state) {
        if (state is user.FirstStartChecked) {
          if (state.isFirstStart == false) {
            if (context.mounted) {
              Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarArguments(tabIndex: 0));
            }
          }
        }
      },
      builder: (context, state) {
        return BlocConsumer<booking.BookingBloc, booking.BookingState>(
          listener: (context, state) {
            if (state is booking.NewBookingsLoaded) {
              for (int i = 0; i < state.bookings.length; i++) {
                if (state.bookings[i].type == BookingType.expense) {
                  BlocProvider.of<AccountBloc>(context).add(AccountWithdraw(booking: state.bookings[i], bookedId: 0, force: true));
                } else if (state.bookings[i].type == BookingType.income) {
                  BlocProvider.of<AccountBloc>(context).add(AccountDeposit(booking: state.bookings[i], bookedId: 0, force: true));
                } else if (state.bookings[i].type == BookingType.transfer || state.bookings[i].type == BookingType.investment) {
                  BlocProvider.of<AccountBloc>(context).add(AccountTransfer(booking: state.bookings[i], bookedId: 0, force: true));
                }
              }
            }
          },
          builder: (context, state) {
            return IntroductionScreen(
              safeAreaList: [true, false, true, false],
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
                  image: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Lottie.asset(
                      'assets/animations/introduction_animation_1.json',
                      fit: BoxFit.contain,
                    ),
                  ),
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
                  image: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Lottie.asset(
                      'assets/animations/introduction_animation_2.json',
                      fit: BoxFit.contain,
                    ),
                  ),
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
                  image: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Lottie.asset(
                      'assets/animations/introduction_animation_3.json',
                      fit: BoxFit.contain,
                    ),
                  ),
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
                  image: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Lottie.asset(
                      'assets/animations/introduction_animation_4.json',
                      fit: BoxFit.contain,
                    ),
                  ),
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
          },
        );
      },
    );
  }
}
