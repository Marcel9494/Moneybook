import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../../core/consts/common_consts.dart';
import '../../../core/consts/database_consts.dart';
import '../../../core/consts/route_consts.dart';
import '../../../features/bookings/presentation/bloc/booking_bloc.dart';
import '../../../features/user/presentation/bloc/user_bloc.dart';
import '../../../main.dart';
import '../bloc/shared_bloc.dart';
import '../widgets/arguments/bottom_nav_bar_arguments.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<void> getLanguageAndCurrency(BuildContext context, bool isFirstStart) async {
    Locale startLocale;
    db = await openDatabase(localDbName);
    try {
      if (isFirstStart) {
        startLocale = WidgetsBinding.instance.platformDispatcher.locale;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          MyApp.of(context)?.setLocale(startLocale);
        });
        return;
      }

      List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$userDbName'",
      );

      if (result.isEmpty) {
        startLocale = WidgetsBinding.instance.platformDispatcher.locale;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          MyApp.of(context)?.setLocale(startLocale);
        });
        return;
      }

      List<Map<String, dynamic>> language = await db.rawQuery('SELECT language FROM $userDbName');
      if (language.isNotEmpty && language.first['language'] != null) {
        Locale loadedLocale = Locale(language.first['language']);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          MyApp.of(context)?.setLocale(loadedLocale);
        });
      } else {
        throw Exception('No language was found in database.');
      }

      List<Map<String, dynamic>> currency = await db.rawQuery('SELECT currency FROM $userDbName');
      if (currency.isNotEmpty && currency.first['currency'] != null) {
        String loadedCurrency = currency.first['currency'];
        locale = (loadedCurrency == "€") ? 'de-DE' : 'en-US';
      } else {
        throw Exception('No currency was found in database.');
      }
    } catch (e) {
      debugPrint('User language could not be loaded: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkStartConditions();
    });
  }

  void _checkStartConditions() {
    BlocProvider.of<SharedBloc>(context).add(const CreateDatabase());
    BlocProvider.of<BookingBloc>(context).add(const HandleAndUpdateNewBookings());
    BlocProvider.of<UserBloc>(context).add(CheckFirstStart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) async {
          if (state is FirstStartChecked) {
            await getLanguageAndCurrency(context, state.isFirstStart);
            if (state.isFirstStart == false) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.popAndPushNamed(
                  context,
                  bottomNavBarRoute,
                  arguments: BottomNavBarArguments(tabIndex: 0),
                );
              });
            } else {
              Navigator.popAndPushNamed(context, introductionRoute);
            }
          }
        },
        child: const Center(
          child: SizedBox(
            width: 54.0,
            height: 54.0,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
