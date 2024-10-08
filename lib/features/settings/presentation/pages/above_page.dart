import 'package:flutter/material.dart';
import 'package:moneybook/core/consts/database_consts.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AbovePage extends StatefulWidget {
  const AbovePage({super.key});

  @override
  State<AbovePage> createState() => _AbovePageState();
}

class _AbovePageState extends State<AbovePage> {
  String appVersion = 'Lade App Version...';

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
        title: const Text('Über Moneybook'),
      ),
      body: ListView(
        children: [
          Card(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Aktuelle App Version',
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
                    'DB Version $localDbVersion',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 12.0, bottom: 24.0),
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'App Entwickler',
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
                      applicationName: 'Moneybook',
                      applicationVersion: 'V $appVersion',
                      applicationLegalese: '© ${DateTime.now().year} Marcel',
                    ),
                  ),
                );
              },
              child: const Text('Lizenzen anzeigen'),
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
