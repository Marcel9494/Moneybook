import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/core/consts/common_consts.dart';
import 'package:moneybook/features/settings/presentation/widgets/cards/setting_card.dart';
import 'package:moneybook/features/settings/presentation/widgets/deco/setting_title.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/consts/database_consts.dart';
import '../../../../core/consts/route_consts.dart';
import '../../../../shared/presentation/bloc/shared_bloc.dart';
import '../../../../shared/presentation/widgets/arguments/bottom_nav_bar_arguments.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
              title: 'Allgemein',
              paddingTop: 0.0,
            ),
            SettingCard(
              title: 'Folge Moneybook',
              icon: Icons.share_rounded,
              onTap: () => _launchUrl(url: 'https://www.instagram.com/'), // TODO richtigen Link einfügen, sobald Instagram Profil vorhanden ist.
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
