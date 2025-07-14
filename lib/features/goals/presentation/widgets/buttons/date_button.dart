import 'package:flutter/material.dart';

class DateButton extends StatelessWidget {
  final String text;
  final DateTime selectedDate;
  final VoidCallback onPressed;

  const DateButton({
    super.key,
    required this.text,
    required this.selectedDate,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        ),
        child: Column(
          children: [
            Icon(
              Icons.calendar_month_rounded,
              color: Colors.white,
              size: 28.0,
            ),
            SizedBox(height: 6.0),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2.0),
            Text(
              '${selectedDate.day}.${selectedDate.month}.${selectedDate.year}',
              style: TextStyle(
                color: Colors.cyanAccent,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
