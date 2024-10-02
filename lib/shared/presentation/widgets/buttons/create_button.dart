import 'package:flutter/material.dart';

class CreateButton extends StatelessWidget {
  final String text;
  final String createRoute;

  const CreateButton({
    super.key,
    required this.text,
    required this.createRoute,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => Navigator.pushNamed(context, createRoute),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        side: BorderSide(width: 0.75, color: Colors.cyanAccent.withOpacity(0.75)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 13.0)),
    );
  }
}
