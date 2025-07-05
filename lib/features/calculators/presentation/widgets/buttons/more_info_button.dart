import 'package:flutter/material.dart';

class MoreInfoButton extends StatelessWidget {
  final String text;

  const MoreInfoButton({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: OutlinedButton(
        onPressed: () => {},
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(20.0, 0, 8.0, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          side: BorderSide(width: 0.75, color: Colors.cyanAccent.withOpacity(0.75)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style: const TextStyle(fontSize: 13.0)),
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Icon(
                Icons.keyboard_arrow_right_rounded,
                size: 24.0,
                color: Colors.cyanAccent.withOpacity(0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
