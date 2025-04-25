import 'package:flutter/material.dart';

import '../../../../../core/utils/app_localizations.dart';

class GridViewButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const GridViewButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(6.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
        ),
      ),
      child: Text(
        AppLocalizations.of(context).translate(text),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14.0),
      ),
    );
  }
}
