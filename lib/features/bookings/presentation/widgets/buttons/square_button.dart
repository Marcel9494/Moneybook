import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const SquareButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.cyanAccent,
          fontSize: 26.0,
        ),
      ),
    );
  }
}
