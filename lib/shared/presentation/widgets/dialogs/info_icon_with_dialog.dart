import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoIconWithDialog extends StatelessWidget {
  final String title;
  final String text;

  const InfoIconWithDialog({
    super.key,
    required this.title,
    required this.text,
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
        size: 17.0,
      ),
    );
  }
}
