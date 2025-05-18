import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:moneybook/core/consts/common_consts.dart';
import 'package:moneybook/core/utils/number_formatter.dart';
import 'package:moneybook/features/settings/presentation/widgets/cards/setting_card.dart';
import 'package:moneybook/features/settings/presentation/widgets/deco/setting_title.dart';
import 'package:moneybook/features/user/presentation/bloc/user_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/configs/overall_configs.dart';
import '../../../../core/consts/database_consts.dart';
import '../../../../core/consts/route_consts.dart';
import '../../../../core/utils/app_localizations.dart';
import '../../../../core/utils/database_backup.dart';
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
                  BottomSheetHeader(title: AppLocalizations.of(context).translate('sprache_ändern') + ':', indent: 16.0),
                  GestureDetector(
                    onTap: () => _getCurrentLanguage() != 'Deutsch' ? _showChangeLanguageInfoDialog(context, 'Deutsch') : {},
                    child: ListTile(
                      leading: CountryFlag.fromCountryCode(
                        'DE',
                        width: 28.0,
                        height: 28.0,
                        shape: const Circle(),
                      ),
                      title: Text(
                        AppLocalizations.of(context).translate('deutsch') +
                            ' ${_getCurrentLanguage() == 'Deutsch' ? '(' + AppLocalizations.of(context).translate('aktuelle_sprache') + ')' : ''}',
                        style: TextStyle(color: _getCurrentLanguage() == 'Deutsch' ? Colors.cyanAccent : Colors.white),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: _getCurrentLanguage() == 'Deutsch' ? Colors.cyanAccent : Colors.white,
                      ),
                    ),
                  ),
                  const Divider(indent: 16.0, endIndent: 16.0),
                  GestureDetector(
                    onTap: () => _showChangeLanguageInfoDialog(context, 'Englisch'),
                    child: ListTile(
                      leading: CountryFlag.fromCountryCode(
                        'US',
                        width: 28.0,
                        height: 28.0,
                        shape: const Circle(),
                      ),
                      title: Text(
                        AppLocalizations.of(context).translate('englisch') +
                            ' ${_getCurrentLanguage() == 'English' ? '(' + AppLocalizations.of(context).translate('aktuelle_sprache') + ')' : ''}',
                        style: TextStyle(color: _getCurrentLanguage() == 'English' ? Colors.cyanAccent : Colors.white),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: _getCurrentLanguage() == 'English' ? Colors.cyanAccent : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showChangeLanguageInfoDialog(BuildContext context, String newLanguage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('sprache_ändern')),
          content: Text(AppLocalizations.of(context).translate('sprache_ändern_beschreibung')),
          actions: [
            TextButton(
              child: Text(
                AppLocalizations.of(context).translate('abbrechen'),
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context).translate('ok')),
              onPressed: () {
                _changeLanguage(context, newLanguage);
              },
            ),
          ],
        );
      },
    );
  }

  void _changeLanguage(BuildContext context, String newLanguage) {
    if (newLanguage == 'Englisch') {
      MyApp.of(context)?.setLocale(Locale('en', 'US'));
      BlocProvider.of<UserBloc>(context).add(UpdateLanguage(newLanguageCode: 'en-US'));
    } else if (newLanguage == 'Deutsch') {
      MyApp.of(context)?.setLocale(Locale('de', 'DE'));
      BlocProvider.of<UserBloc>(context).add(UpdateLanguage(newLanguageCode: 'de-DE'));
    }
    setState(() {
      Navigator.pop(context);
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
                  BottomSheetHeader(title: AppLocalizations.of(context).translate('währung_ändern') + ':', indent: 16.0),
                  GestureDetector(
                    onTap: () => locale != 'de-DE' ? _showChangeMainCurrencyInfoDialog(context, 'Euro') : {},
                    child: ListTile(
                      leading: const Text('🇪🇺', style: TextStyle(fontSize: 22.0)),
                      title: Text('Euro ${locale == 'de-DE' ? '(' + AppLocalizations.of(context).translate('aktuelle_währung') + ')' : ''}',
                          style: TextStyle(color: locale == 'de-DE' ? Colors.cyanAccent : Colors.white)),
                      trailing: Text('€', style: TextStyle(fontSize: 18.0, color: locale == 'de-DE' ? Colors.cyanAccent : Colors.white)),
                    ),
                  ),
                  const Divider(indent: 16.0, endIndent: 16.0),
                  GestureDetector(
                    onTap: () => locale != 'en-US' ? _showChangeMainCurrencyInfoDialog(context, 'Dollar') : {},
                    child: ListTile(
                      leading: CountryFlag.fromCountryCode(
                        'US',
                        width: 28.0,
                        height: 28.0,
                        shape: const Circle(),
                      ),
                      title: Text('Dollar ${locale == 'en-US' ? '(' + AppLocalizations.of(context).translate('aktuelle_währung') + ')' : ''}',
                          style: TextStyle(color: locale == 'en-US' ? Colors.cyanAccent : Colors.white)),
                      trailing: Text(
                        '\$',
                        style: TextStyle(fontSize: 18.0, color: locale == 'en-US' ? Colors.cyanAccent : Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showChangeMainCurrencyInfoDialog(BuildContext context, String newCurrency) async {
    bool _convertBudgetAmounts = false;
    double? _exchangeRate = 1.0;
    String fromCurrency = '';
    String toCurrency = '';
    String toCurrencySymbol = '';
    const WidgetStateProperty<Icon> _thumbIcon = WidgetStateProperty<Icon>.fromMap(
      <WidgetStatesConstraint, Icon>{
        WidgetState.selected: Icon(Icons.check),
        WidgetState.any: Icon(Icons.close),
      },
    );
    if (newCurrency == 'Dollar') {
      fromCurrency = 'EUR';
      toCurrency = 'USD';
      toCurrencySymbol = '\$';
    } else if (newCurrency == 'Euro') {
      fromCurrency = 'USD';
      toCurrency = 'EUR';
      toCurrencySymbol = '€';
    }
    if (await InternetConnection().hasInternetAccess) {
      final response = await http.get(Uri.parse('https://api.frankfurter.app/latest?base=$toCurrency'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _exchangeRate = data['rates'][fromCurrency];
      } else {
        Flushbar(
          title: AppLocalizations.of(context).translate('wechselkurs_abfrage'),
          message: AppLocalizations.of(context).translate('wechselkurs_abfrage_fehlermeldung'),
          icon: const Icon(Icons.error_outline_rounded, color: Colors.redAccent),
          duration: const Duration(milliseconds: flushbarDurationInMs),
          leftBarIndicatorColor: Colors.redAccent,
          flushbarPosition: FlushbarPosition.TOP,
        ).show(context);
        return;
      }
    } else {
      Flushbar(
        title: AppLocalizations.of(context).translate('internetverbindung_fehler_titel'),
        message: AppLocalizations.of(context).translate('internetverbindung_fehler_beschreibung'),
        icon: const Icon(Icons.error_outline_rounded, color: Colors.redAccent),
        duration: const Duration(milliseconds: flushbarDurationInMs),
        leftBarIndicatorColor: Colors.redAccent,
        flushbarPosition: FlushbarPosition.TOP,
      ).show(context);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context).translate('währung_ändern')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context).translate('währung_ändern_beschreibung') +
                        '\n\n1.00 ' +
                        toCurrencySymbol +
                        ' = ' +
                        formatToMoneyAmount(_exchangeRate.toString()),
                  ),
                  SizedBox(height: 24.0),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          AppLocalizations.of(context).translate('budget_umrechnen_beschreibung'),
                          softWrap: true,
                        ),
                      ),
                      Switch(
                        thumbIcon: _thumbIcon,
                        value: _convertBudgetAmounts,
                        onChanged: (newConvertBudgetAmounts) {
                          setState(() {
                            _convertBudgetAmounts = newConvertBudgetAmounts;
                          });
                        },
                        activeTrackColor: Colors.cyanAccent,
                        activeColor: Colors.cyan,
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text(
                    AppLocalizations.of(context).translate('abbrechen'),
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(AppLocalizations.of(context).translate('ok')),
                  onPressed: () {
                    _changeMainCurrency(newCurrency, _convertBudgetAmounts);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _changeMainCurrency(String newLanguage, bool convertBudgetAmounts) {
    if (newLanguage == 'Dollar') {
      mainCurrency = '\$';
      locale = 'en-US';
      BlocProvider.of<UserBloc>(context).add(UpdateCurrency(newCurrency: mainCurrency, convertBudgetAmounts: convertBudgetAmounts));
    } else if (newLanguage == 'Euro') {
      mainCurrency = '€';
      locale = 'de-DE';
      BlocProvider.of<UserBloc>(context).add(UpdateCurrency(newCurrency: mainCurrency, convertBudgetAmounts: convertBudgetAmounts));
    }
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

  String _getCurrentLanguage() {
    Locale currentLocale = Localizations.localeOf(context);
    if (currentLocale == Locale('de')) {
      return 'Deutsch';
    } else if (currentLocale == Locale('en')) {
      return 'English';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('einstellungen')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingTitle(
                title: AppLocalizations.of(context).translate('app') + ' ' + AppLocalizations.of(context).translate('einstellungen'),
                paddingTop: 6.0,
              ),
              SettingCard(
                title: AppLocalizations.of(context).translate('sprache') + ': ' + _getCurrentLanguage(),
                icon: Icons.language_rounded,
                onTap: () => _openLanguageBottomSheet(context),
              ),
              BlocListener<UserBloc, UserState>(
                listener: (context, state) {
                  if (state is CurrencyUpdated) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      bottomNavBarRoute,
                      arguments: BottomNavBarArguments(tabIndex: 0),
                      (Route<dynamic> route) => false,
                    );
                    Navigator.pushNamed(context, settingsRoute);
                  }
                },
                child: SettingCard(
                  // locale wird in der Splash Page gesetzt und repräsentiert auch die Währung
                  title: locale == 'de-DE'
                      ? AppLocalizations.of(context).translate('währung') + ': Euro'
                      : AppLocalizations.of(context).translate('währung') + ': Dollar',
                  icon: Icons.paid_outlined,
                  onTap: () => _openCurrencyBottomSheet(context),
                ),
              ),
              SettingCard(
                title: AppLocalizations.of(context).translate('wechselkurse'),
                icon: Icons.currency_exchange_rounded,
                onTap: () => Navigator.pushNamed(context, currencyConverterRoute),
              ),
              SettingTitle(
                title: AppLocalizations.of(context).translate('backup'),
                paddingTop: 6.0,
              ),
              SettingCard(
                title: AppLocalizations.of(context).translate('backup_exportieren'),
                icon: Icons.file_download_rounded,
                onTap: () => exportDatabaseBackup(),
                isNew: true,
              ),
              SettingCard(
                title: AppLocalizations.of(context).translate('backup_importieren'),
                icon: Icons.file_upload_rounded,
                onTap: () => importDatabaseBackup(),
                isNew: true,
              ),
              SettingTitle(
                title: AppLocalizations.of(context).translate('allgemein'),
                paddingTop: 6.0,
              ),
              SettingCard(
                title: AppLocalizations.of(context).translate('folge') + ' ' + AppLocalizations.of(context).translate('moneybook'),
                icon: Icons.share_rounded,
                onTap: () => _launchUrl(url: 'https://www.instagram.com/moneybook_app'),
              ),
              SettingCard(
                title: AppLocalizations.of(context).translate('über') + ' ' + AppLocalizations.of(context).translate('moneybook'),
                icon: Icons.info_outline_rounded,
                onTap: () => Navigator.pushNamed(context, aboveRoute),
              ),
              SettingTitle(
                title: AppLocalizations.of(context).translate('rechtliches'),
                paddingTop: 6.0,
              ),
              SettingCard(
                title: AppLocalizations.of(context).translate('impressum'),
                icon: Icons.security_rounded,
                onTap: () => Navigator.pushNamed(context, impressumRoute),
              ),
              SettingCard(
                title: AppLocalizations.of(context).translate('datenschutzerklärung'),
                icon: Icons.info_outline_rounded,
                onTap: () => {
                  _launchUrl(url: 'https://marcel9494.github.io/Moneybook/privacyPolicy_' + Localizations.localeOf(context).languageCode + '.html'),
                },
              ),
              SettingCard(
                title: AppLocalizations.of(context).translate('credits'),
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
      ),
    );
  }
}
