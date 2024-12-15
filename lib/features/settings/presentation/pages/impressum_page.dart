import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
        title: Text('Impressum'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('Impressum', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
            ),
            Text('Angaben gemäß § 5 TMG'),
            Text('Marcel Geirhos'),
            Text('Gartenstraße 8, 73550, Waldstetten'),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Text('Kontakt:', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            ),
            Text('Telefon: +49 176 30721919'),
            Text('E-Mail: Marcel.Geirhos@gmail.com'),
            Text('Keine USt-IdNr. vorhanden.'),
            Text('Verantwortlich für den Inhalt nach § 55 Abs. 2 RStV:'),
            Text('Marcel Geirhos'),
            Text('Gartenstraße 8, 73550, Waldstetten'),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Text('Streitschlichtung', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            ),
            Text('Die Europäische Kommission stellt eine Plattform zur Online-Streitbeilegung (OS) bereit:'),
            ElevatedButton(
              onPressed: () => _launchEuropeCommissionSite(url: 'https://ec.europa.eu/consumers/odr/'),
              child: Text('Online Streitbeilegung'),
            ),
            Text('Unsere E-Mail-Adresse finden Sie oben im Impressum.'),
            Text('Wir sind nicht bereit oder verpflichtet, an Streitbeilegungsverfahren vor einer Verbraucherschlichtungsstelle teilzunehmen.'),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('Stand: 11.12.2024'),
            ),
          ],
        ),
      ),
    );
  }
}
