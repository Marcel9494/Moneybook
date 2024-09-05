import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/consts/database_consts.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _launchInstagramAppIfInstalled({required String url}) async {
    try {
      // Launch the app if installed!
      bool launched = await launchUrl(Uri.parse(url));
      if (launched == false) {
        launchUrl(Uri.parse(url)); // Launch web view if app is not installed!
      }
    } catch (e) {
      launchUrl(Uri.parse(url)); // Launch web view if app is not installed!
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Allgemein'),
            tiles: [
              SettingsTile(
                title: const Text('Folge Moneybook'),
                leading: const Icon(Icons.share_rounded),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                backgroundColor: const Color(0xFF1E1E1E),
                onPressed: (BuildContext context) {
                  _launchInstagramAppIfInstalled(
                      url: 'https://www.instagram.com/'); // TODO richtigen Link einfügen, sobald Instagram Profil vorhanden ist.
                },
              ),
              SettingsTile(
                title: const Text('Über die App'),
                leading: const Icon(Icons.info_outline_rounded),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                backgroundColor: const Color(0xFF1E1E1E),
                onPressed: (BuildContext context) {},
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Rechtliches'),
            tiles: [
              SettingsTile(
                title: const Text('Impressum'),
                leading: const Icon(Icons.security_rounded),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                backgroundColor: const Color(0xFF1E1E1E),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: const Text('Datenschutzerklärung'),
                leading: const Icon(Icons.gpp_good_outlined),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                backgroundColor: const Color(0xFF1E1E1E),
                onPressed: (BuildContext context) {},
              ),
            ],
          ),
          SettingsSection(
            title: adminMode ? const Text('Admin Bereich') : const Text(''),
            tiles: adminMode
                ? [
                    SettingsTile.switchTile(
                      title: const Text('Demo Modus'),
                      leading: const Icon(Icons.admin_panel_settings_rounded),
                      backgroundColor: const Color(0xFF1E1E1E),
                      onPressed: (BuildContext context) {},
                      initialValue: demoMode,
                      onToggle: (bool value) {
                        setState(() {
                          demoMode = value;
                          // TODO hier weitermachen und auf Prod und Demo wechseln implementieren
                        });
                      },
                    ),
                  ]
                : [],
          ),
        ],
      ),
    );
  }
}
