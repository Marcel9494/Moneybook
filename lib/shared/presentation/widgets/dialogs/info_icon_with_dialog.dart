import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoIconWithDialog extends StatelessWidget {
  final String title;
  final String text;
  final double iconSize;

  const InfoIconWithDialog({
    super.key,
    required this.title,
    required this.text,
    this.iconSize = 17.0,
  });

  void _showInfoDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showInfoDialog(context);
      },
      child: Icon(
        Icons.info_outline_rounded,
        color: Colors.grey,
        size: iconSize,
      ),
    );
  }
}
