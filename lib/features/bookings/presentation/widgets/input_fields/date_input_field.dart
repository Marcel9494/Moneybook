import 'package:flutter/material.dart';

import '../../../../../core/utils/date_formatter.dart';

class DateInputField extends StatefulWidget {
  final TextEditingController dateController;

  const DateInputField({
    super.key,
    required this.dateController,
  });

  @override
  State<DateInputField> createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.dateController,
      showCursor: false,
      readOnly: true,
      decoration: const InputDecoration(
        hintText: 'Datum',
        counterText: '',
        prefixIcon: IconTheme(
          data: IconThemeData(color: Colors.grey),
          child: Icon(Icons.calendar_month_rounded),
        ),
      ),
      onTap: () async {
        final DateTime? parsedDate = await showDatePicker(
          context: context,
          locale: const Locale('de', 'DE'),
          firstDate: DateTime(DateTime.now().year - 10),
          lastDate: DateTime(DateTime.now().year + 100),
        );
        if (parsedDate != null) {
          setState(() {
            widget.dateController.text = dateFormatterDDMMYYYYEE.format(parsedDate);
          });
        }
      },
    );
  }
}
