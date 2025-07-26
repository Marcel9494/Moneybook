import 'package:flutter/material.dart';

class GradientLine extends StatelessWidget {
  const GradientLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 2,
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white24, Colors.white70],
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
