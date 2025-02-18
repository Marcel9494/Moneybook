import 'package:flutter/material.dart';

class NewLabel extends StatelessWidget {
  const NewLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.cyanAccent.shade400, width: 0.7),
          borderRadius: BorderRadius.circular(7.0),
        ),
        child: Text(
          'Neu',
          style: TextStyle(fontSize: 10.0, color: Colors.cyanAccent.shade400, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
