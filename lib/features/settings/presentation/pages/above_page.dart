import 'package:flutter/material.dart';
import 'package:moneybook/core/consts/database_consts.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/utils/app_localizations.dart';

class AbovePage extends StatefulWidget {
  const AbovePage({super.key});

  @override
  State<AbovePage> createState() => _AbovePageState();
}

class _AbovePageState extends State<AbovePage> {
  String appVersion = '...';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version; // Holt die App Version aus der pubspec.yaml
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('über') + ' ' + AppLocalizations.of(context).translate('moneybook')),
      ),
      body: ListView(
        children: [
          Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/moneybook_app_icon.png',
                      width: 72.0,
                      height: 72.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    AppLocalizations.of(context).translate('aktuelle_app_version'),
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'V $appVersion',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    AppLocalizations.of(context).translate('db_version') + ' $localDbVersion',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0, bottom: 24.0),
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      AppLocalizations.of(context).translate('app_entwickler'),
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Text('Marcel'),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Marcel.Geirhos@gmail.com'),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LicensePage(
                      applicationName: AppLocalizations.of(context).translate('moneybook'),
                      applicationVersion: 'V $appVersion',
                      applicationLegalese: '© ${DateTime.now().year} Marcel',
                    ),
                  ),
                );
              },
              child: Text(AppLocalizations.of(context).translate('lizenzen_anzeigen')),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Center(
              child: Text('Made in Germany'),
            ),
          ),
        ],
      ),
    );
  }
}
