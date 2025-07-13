import 'package:flutter/material.dart';

class DateButton extends StatefulWidget {
  final String text;
  final DateTime startDate;

  const DateButton({
    super.key,
    required this.text,
    required this.startDate,
  });

  @override
  State<DateButton> createState() => _DateButtonState();
}

class _DateButtonState extends State<DateButton> {
  DateTime? _selectedDate;

  initState() {
    super.initState();
    _selectedDate = widget.startDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.startDate,
      firstDate: DateTime(2014),
      lastDate: DateTime(DateTime.now().year + 100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ElevatedButton(
        onPressed: () => _selectDate(context),
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
              color: _selectedDate == null ? Colors.grey : Colors.white,
              size: 28.0,
            ),
            SizedBox(height: 6.0),
            Text(
              widget.text,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2.0),
            Text(
              _selectedDate == null ? '' : '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}',
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
