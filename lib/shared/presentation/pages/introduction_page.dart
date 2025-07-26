import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../../../core/consts/common_consts.dart';
import '../../../core/consts/route_consts.dart';
import '../../../core/utils/app_localizations.dart';
import '../../../core/utils/currency_helper.dart';
import '../../../features/user/domain/entities/user.dart';
import '../../../features/user/presentation/bloc/user_bloc.dart' as user;
import '../bloc/shared_bloc.dart';
import '../widgets/animations/text_fade_animation.dart';
import '../widgets/arguments/bottom_nav_bar_arguments.dart';
import '../widgets/deco/gradient_line.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  void _endOfInstruction() {
    String currency = CurrencyHelper.getCurrencyFromCountry(locale);

    BlocProvider.of<SharedBloc>(context).add(const CreateStartDatabaseValues());
    BlocProvider.of<user.UserBloc>(context).add(
      user.CreateUser(
        user: User(
          id: 0,
          firstStart: false,
          lastStart: DateTime.now(),
          language: locale,
          currency: currency,
          localDb: true,
        ),
      ),
    );
    Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarArguments(tabIndex: 0));
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      safeAreaList: [true, false, true, false],
      pages: [
        PageViewModel(
          titleWidget: Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const GradientLine(),
                const SizedBox(height: 24.0),
                TextFadeAnimation(
                  text: AppLocalizations.of(context).translate('erste_einführungsseite_titel'),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
          ),
          bodyWidget: TextFadeAnimation(
            text: AppLocalizations.of(context).translate('erste_einführungsseite_text'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
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
          titleWidget: Padding(
            padding: EdgeInsets.only(top: 48.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const GradientLine(),
                const SizedBox(height: 24.0),
                TextFadeAnimation(
                  text: AppLocalizations.of(context).translate('zweite_einführungsseite_titel'),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
          ),
          bodyWidget: TextFadeAnimation(
            text: AppLocalizations.of(context).translate('zweite_einführungsseite_text'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
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
          titleWidget: Padding(
            padding: EdgeInsets.only(top: 48.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const GradientLine(),
                const SizedBox(height: 24.0),
                TextFadeAnimation(
                  text: AppLocalizations.of(context).translate('dritte_einführungsseite_titel'),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
          ),
          bodyWidget: TextFadeAnimation(
            text: AppLocalizations.of(context).translate('dritte_einführungsseite_text'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
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
          titleWidget: Padding(
            padding: EdgeInsets.only(top: 48.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const GradientLine(),
                const SizedBox(height: 24.0),
                TextFadeAnimation(
                  text: AppLocalizations.of(context).translate('vierte_einführungsseite_titel'),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
          ),
          bodyWidget: TextFadeAnimation(
            text: AppLocalizations.of(context).translate('vierte_einführungsseite_text'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
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
      skip: Padding(
        padding: EdgeInsets.only(bottom: 36.0),
        child: Text(AppLocalizations.of(context).translate('überspringen'), style: TextStyle(color: Colors.white)),
      ),
      next: Padding(
        padding: const EdgeInsets.only(bottom: 36.0),
        child: Text(AppLocalizations.of(context).translate('weiter')),
      ),
      done: Padding(
        padding: const EdgeInsets.only(bottom: 36.0),
        child: Text(AppLocalizations.of(context).translate('fertig'), style: TextStyle(fontWeight: FontWeight.w700)),
      ),
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
        spacing: const EdgeInsets.only(left: 3.0, right: 3.0, bottom: 36.0),
        activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
    );
  }
}
