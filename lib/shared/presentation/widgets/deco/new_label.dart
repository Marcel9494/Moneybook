import 'package:flutter/material.dart';

import '../../../../core/utils/app_localizations.dart';

class NewLabel extends StatelessWidget {
  const NewLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
        decoration: BoxDecoration(
          color: Colors.cyanAccent.shade400.withOpacity(0.18),
          border: Border.all(color: Colors.cyanAccent.shade400, width: 0.7),
          borderRadius: BorderRadius.circular(7.0),
        ),
        child: Text(
          AppLocalizations.of(context).translate('neu'),
          style: TextStyle(fontSize: 10.0, color: Colors.cyanAccent.shade400, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
