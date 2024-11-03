import 'package:flutter/material.dart';
import 'package:moneybook/core/utils/number_formatter.dart';

import '../../../../../core/utils/date_formatter.dart';

class DailyReportSummary extends StatelessWidget {
  final DateTime date;
  final double? rightValue;
  final double? leftValue;
  final bool showLeftValue;

  const DailyReportSummary({
    super.key,
    required this.date,
    required this.rightValue,
    this.leftValue = 0.0,
    this.showLeftValue = true,
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
          showLeftValue
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 0.0),
                  child: Text(
                    formatToMoneyAmount(leftValue.toString()),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.greenAccent),
                  ),
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 0.0),
            child: Text(
              formatToMoneyAmount(rightValue.toString()),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
