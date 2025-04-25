import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/app_localizations.dart';

class ImpressumPage extends StatelessWidget {
  const ImpressumPage({super.key});

  Future<void> _launchEuropeCommissionSite({required String url}) async {
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
        title: Text(AppLocalizations.of(context).translate('impressum')),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(AppLocalizations.of(context).translate('impressum'), style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
            ),
            Text(AppLocalizations.of(context).translate('angaben_gemäß')),
            Text('Marcel Geirhos'),
            Text('Gartenstraße 8, 73550, Waldstetten'),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Text(AppLocalizations.of(context).translate('kontakt') + ':', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            ),
            Text(AppLocalizations.of(context).translate('telefon') + ':' + ' +49 176 30721919'),
            Text(AppLocalizations.of(context).translate('e-mail') + ':' + ' Marcel.Geirhos@gmail.com'),
            Text(AppLocalizations.of(context).translate('ustidnr')),
            Text(AppLocalizations.of(context).translate('verantwortlich_für_inhalt')),
            Text('Marcel Geirhos'),
            Text('Gartenstraße 8, 73550, Waldstetten'),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Text(AppLocalizations.of(context).translate('streitschlichtung'), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            ),
            Text(AppLocalizations.of(context).translate('eu_kommission')),
            ElevatedButton(
              onPressed: () => _launchEuropeCommissionSite(url: 'https://ec.europa.eu/consumers/odr/'),
              child: Text(AppLocalizations.of(context).translate('online_streitbeilegung')),
            ),
            Text(AppLocalizations.of(context).translate('online_streitbeilegung_beschreibung')),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(AppLocalizations.of(context).translate('stand') + ':' + ' 11.12.2024'),
            ),
          ],
        ),
      ),
    );
  }
}
