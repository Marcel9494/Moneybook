import 'package:flutter/material.dart';

class SecondActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SecondActionButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            side: const BorderSide(color: Colors.cyanAccent),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
