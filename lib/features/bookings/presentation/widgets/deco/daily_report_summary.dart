import 'package:flutter/material.dart';
import 'package:moneybook/core/utils/number_formatter.dart';

import '../../../../../core/utils/date_formatter.dart';

class DailyReportSummary extends StatelessWidget {
  final DateTime date;
  final double? dailyIncome;
  final double? dailyExpense;

  const DailyReportSummary({
    super.key,
    required this.date,
    required this.dailyIncome,
    required this.dailyExpense,
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
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              formatToMoneyAmount(dailyIncome.toString()),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.greenAccent),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              formatToMoneyAmount(dailyExpense.toString()),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
