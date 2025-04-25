import 'package:flutter/material.dart';

import '../../../../../core/utils/app_localizations.dart';

class ListViewButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String selectedValue;

  const ListViewButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          side: BorderSide(
              color: AppLocalizations.of(context).translate(text) == AppLocalizations.of(context).translate(selectedValue)
                  ? Colors.cyanAccent
                  : Colors.grey),
        ),
        child: Text(
          AppLocalizations.of(context).translate(text),
          style: TextStyle(
              color: AppLocalizations.of(context).translate(text) == AppLocalizations.of(context).translate(selectedValue)
                  ? Colors.cyanAccent
                  : Colors.white),
        ),
      ),
    );
  }
}
