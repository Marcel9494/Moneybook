import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
              // TODO hier weitermachen und onPressed implementieren siehe navigation_widget für Funktion
              SettingsTile(
                title: const Text('Folge Moneybook'),
                leading: const Icon(Icons.share_rounded),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                backgroundColor: const Color(0xFF1E1E1E),
                onPressed: (BuildContext context) {},
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
        ],
      ),
    );
  }
}
