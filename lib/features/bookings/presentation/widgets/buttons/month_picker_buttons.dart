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
                monthPickerDialogSettings: MonthPickerDialogSettings(
                  headerSettings: PickerHeaderSettings(
                    headerCurrentPageTextStyle: TextStyle(fontSize: 16.0),
                    headerSelectedIntervalTextStyle: TextStyle(fontSize: 20.0),
                    headerBackgroundColor: Colors.black26,
                  ),
                  dialogSettings: PickerDialogSettings(
                    dismissible: true,
                    locale: const Locale(locale),
                    dialogRoundedCornersRadius: 20.0,
                    dialogBackgroundColor: Colors.black26,
                  ),
                  dateButtonsSettings: PickerDateButtonsSettings(
                    buttonBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    ),
                    selectedMonthBackgroundColor: Colors.cyanAccent,
                    selectedMonthTextColor: Colors.white,
                    unselectedMonthsTextColor: Colors.white70,
                    currentMonthTextColor: Colors.cyanAccent,
                    yearTextStyle: const TextStyle(
                      fontSize: 15.0,
                    ),
                    monthTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  actionBarSettings: PickerActionBarSettings(
                    buttonSpacing: 12.0,
                    customDivider: Divider(height: 1.0),
                    confirmWidget: const Text('OK', style: TextStyle(color: Colors.cyanAccent)),
                    cancelWidget: const Text('Abbrechen', style: TextStyle(color: Colors.grey)),
                  ),
                ),
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
