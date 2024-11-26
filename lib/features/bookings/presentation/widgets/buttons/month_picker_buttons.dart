import 'package:flutter/material.dart';
import 'package:moneybook/core/consts/common_consts.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../../../../../core/utils/date_formatter.dart';

class MonthPickerButtons extends StatefulWidget {
  DateTime selectedDate;
  final Function(DateTime selectedDate) selectedDateCallback;

  MonthPickerButtons({
    super.key,
    required this.selectedDate,
    required this.selectedDateCallback,
  });

  @override
  State<MonthPickerButtons> createState() => _MonthPickerButtonsState();
}

class _MonthPickerButtonsState extends State<MonthPickerButtons> {
  void _previousMonth() {
    setState(() {
      widget.selectedDate = DateTime(widget.selectedDate.year, widget.selectedDate.month - 1, 1);
      widget.selectedDateCallback(widget.selectedDate);
    });
  }

  void _nextMonth() {
    setState(() {
      widget.selectedDate = DateTime(widget.selectedDate.year, widget.selectedDate.month + 1, 1);
      widget.selectedDateCallback(widget.selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => _previousMonth(),
          icon: const Icon(Icons.keyboard_arrow_left_rounded),
        ),
        SizedBox(
          width: 76.0,
          child: GestureDetector(
            onTap: () {
              showMonthPicker(
                context: context,
                initialDate: widget.selectedDate,
                selectedMonthBackgroundColor: Colors.cyanAccent,
                unselectedMonthTextColor: Colors.white70,
                confirmWidget: const Text('OK', style: TextStyle(color: Colors.cyanAccent)),
                cancelWidget: const Text('Abbrechen', style: TextStyle(color: Colors.cyanAccent)),
                locale: const Locale(locale),
                roundedCornersRadius: 12.0,
                dismissible: true,
              ).then((date) {
                if (date != null) {
                  setState(() {
                    widget.selectedDate = date;
                    widget.selectedDateCallback(widget.selectedDate);
                  });
                }
              });
            },
            behavior: HitTestBehavior.translucent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(dateFormatterMMMYYYY.format(widget.selectedDate), textAlign: TextAlign.center),
            ),
          ),
        ),
        IconButton(
          onPressed: () => _nextMonth(),
          icon: const Icon(Icons.keyboard_arrow_right_rounded),
        ),
      ],
    );
  }
}
