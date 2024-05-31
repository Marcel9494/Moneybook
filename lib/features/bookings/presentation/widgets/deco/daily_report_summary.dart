import 'package:flutter/material.dart';

import '../../../../../core/utils/date_formatter.dart';

class DailyReportSummary extends StatelessWidget {
  final DateTime date;

  const DailyReportSummary({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8.0, 1.5, 6.0, 1.5),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Text(
                      dateFormatterEEDD.format(date),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
                const WidgetSpan(
                  child: SizedBox(width: 6.0),
                ),
                WidgetSpan(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 1.5),
                    child: Text(
                      dateFormatterMMYYYY.format(date),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Text(
            'Einnahmen',
            style: TextStyle(color: Colors.greenAccent),
          ),
          const Text(
            'Ausgaben',
            style: TextStyle(color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
