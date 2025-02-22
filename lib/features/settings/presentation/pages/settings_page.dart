import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:moneybook/core/consts/common_consts.dart';
import 'package:moneybook/features/settings/presentation/widgets/cards/setting_card.dart';
import 'package:moneybook/features/settings/presentation/widgets/deco/setting_title.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/configs/overall_configs.dart';
import '../../../../core/consts/database_consts.dart';
import '../../../../core/consts/route_consts.dart';
import '../../../../main.dart';
import '../../../../shared/presentation/bloc/shared_bloc.dart';
import '../../../../shared/presentation/widgets/arguments/bottom_nav_bar_arguments.dart';
import '../../../../shared/presentation/widgets/deco/bottom_sheet_header.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _openLanguageBottomSheet(BuildContext context) {
    showCupertinoModalBottomSheet<void>(
      context: context,
      backgroundColor: Color(0xFF1c1b20),
      builder: (BuildContext context) {
        return Material(
          color: Color(0xFF1c1b20),
          child: Wrap(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BottomSheetHeader(title: 'Sprache ändern:', indent: 16.0),
                  ListTile(
                    leading: CountryFlag.fromCountryCode(
                      'DE',
                      width: 28.0,
                      height: 28.0,
                      shape: const Circle(),
                    ),
                    title: const Text('Deutsch'),
                    trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                    onTap: () => _changeLanguage(context, 'Deutsch'),
                  ),
                  const Divider(indent: 16.0, endIndent: 16.0),
                  ListTile(
                    leading: CountryFlag.fromCountryCode(
                      'US',
                      width: 28.0,
                      height: 28.0,
                      shape: const Circle(),
                    ),
                    title: const Text('Englisch'),
                    trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                    onTap: () => _changeLanguage(context, 'Englisch'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _changeLanguage(BuildContext context, String newLanguage) {
    // TODO hier weitermachen und Daten in User Datenbanktabelle speichern und laden
    if (newLanguage == 'Englisch') {
      language = 'Englisch';
      MyApp.of(context)?.setLocale(Locale('en', 'US'));
      //locale = 'en-US';
      //singleLocale = 'en';
    } else if (newLanguage == 'Deutsch') {
      language = 'Deutsch';
      MyApp.of(context)?.setLocale(Locale('de', 'DE'));
      //locale = 'de-DE';
      //singleLocale = 'de';
    }
    setState(() {
      Navigator.pop(context);
    });
  }

  void _openCurrencyBottomSheet(BuildContext context) {
    showCupertinoModalBottomSheet<void>(
      context: context,
      backgroundColor: Color(0xFF1c1b20),
      builder: (BuildContext context) {
        return Material(
          color: Color(0xFF1c1b20),
          child: Wrap(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BottomSheetHeader(title: 'Währung ändern:', indent: 16.0),
                  ListTile(
                    leading: const Text('🇪🇺', style: TextStyle(fontSize: 22.0)),
                    title: const Text('Euro'),
                    trailing: const Text(
                      '€',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    onTap: () => _changeMainCurrency('Euro'),
                  ),
                  const Divider(indent: 16.0, endIndent: 16.0),
                  ListTile(
                    leading: CountryFlag.fromCountryCode(
                      'US',
                      width: 28.0,
                      height: 28.0,
                      shape: const Circle(),
                    ),
                    title: const Text('Dollar'),
                    trailing: const Text(
                      '\$',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    onTap: () => _changeMainCurrency('Dollar'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _changeMainCurrency(String newLanguage) {
    // TODO hier weitermachen und Daten in User Datenbanktabelle speichern und laden
    if (newLanguage == 'Dollar') {
      mainCurrency = '\$';
      currencyString = 'Dollar';
    } else if (newLanguage == 'Euro') {
      mainCurrency = '€';
      currencyString = 'Euro';
    }
    setState(() {
      Navigator.pop(context);
    });
  }

  Future<void> _launchUrl({required String url}) async {
    try {
      bool launched = await launchUrl(Uri.parse(url));
      if (launched == false) {
        launchUrl(Uri.parse(url));
      }
    } catch (e) {
      launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingTitle(
              title: 'App Einstellungen',
              paddingTop: 0.0,
            ),
            SettingCard(
              title: 'Sprache: ${language}',
              icon: Icons.language_rounded,
              onTap: () => _openLanguageBottomSheet(context),
            ),
            SettingCard(
              title: 'Währung: ${currencyString}',
              icon: Icons.paid_outlined,
              onTap: () => _openCurrencyBottomSheet(context),
            ),
            SettingCard(
              title: 'Wechselkurse',
              icon: Icons.currency_exchange_rounded,
              onTap: () => Navigator.pushNamed(context, currencyConverterRoute),
            ),
            SettingTitle(
              title: 'Allgemein',
              paddingTop: 0.0,
            ),
            SettingCard(
              title: 'Folge Moneybook',
              icon: Icons.share_rounded,
              onTap: () => _launchUrl(url: 'https://www.instagram.com/moneybook_app'),
            ),
            SettingCard(
              title: 'Über Moneybook',
              icon: Icons.info_outline_rounded,
              onTap: () => Navigator.pushNamed(context, aboveRoute),
            ),
            SettingTitle(title: 'Rechtliches'),
            SettingCard(
              title: 'Impressum',
              icon: Icons.security_rounded,
              onTap: () => Navigator.pushNamed(context, impressumRoute),
            ),
            SettingCard(
              title: 'Datenschutzerklärung',
              icon: Icons.info_outline_rounded,
              onTap: () => {
                _launchUrl(url: 'https://marcel9494.github.io/Moneybook/privacyPolicy.html'),
              },
            ),
            SettingCard(
              title: 'Credits',
              icon: Icons.receipt_long_rounded,
              onTap: () => Navigator.pushNamed(context, creditRoute),
            ),
            adminMode ? SettingTitle(title: 'Admin Bereich') : const SizedBox(),
            adminMode
                ? Card(
                    child: ListTile(
                      title: const Text('Demo Modus'),
                      leading: const Icon(Icons.admin_panel_settings_rounded),
                      trailing: Switch(
                        value: demoMode,
                        activeColor: Colors.cyanAccent,
                        onChanged: (bool value) {
                          setState(() {
                            demoMode = value;
                            switchDemoMode(demoMode);
                            BlocProvider.of<SharedBloc>(context).add(const CreateDatabase());
                            Navigator.pop(context);
                            Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarArguments(tabIndex: 0));
                          });
                        },
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
