import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  final String text;
  final IconData icon;

  const EmptyList({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 46.0),
        const SizedBox(height: 12.0),
        Text(text, textAlign: TextAlign.center),
      ],
    );
  }
}
