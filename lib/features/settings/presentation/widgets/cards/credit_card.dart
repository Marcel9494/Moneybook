import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/utils/app_localizations.dart';

class CreditCard extends StatelessWidget {
  final String graphicName;
  final String graphicUrl;
  final String creatorName;
  final String creatorUrl;
  final String license;
  final String licenseUrl;

  const CreditCard({
    super.key,
    required this.graphicName,
    required this.graphicUrl,
    required this.creatorName,
    required this.creatorUrl,
    required this.license,
    required this.licenseUrl,
  });

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
    return Card(
      child: Column(
        children: [
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                graphicName,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.lightBlueAccent,
                ),
              ),
            ),
            onTap: () => _launchUrl(url: graphicUrl),
          ),
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                AppLocalizations.of(context).translate('von') + ' $creatorName,',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            onTap: () => _launchUrl(url: creatorUrl),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).translate('lizenziert_unter_der') + ' ',
                ),
                GestureDetector(
                  child: Text(
                    '$license',
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                  onTap: () => _launchUrl(url: licenseUrl),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
