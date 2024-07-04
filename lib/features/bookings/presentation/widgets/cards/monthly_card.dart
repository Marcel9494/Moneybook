import 'package:flutter/material.dart';

import '../../../../../core/utils/number_formatter.dart';

class MonthlyCard extends StatelessWidget {
  final String title;
  final double monthlyValue;
  final double dailyAverageValue;

  const MonthlyCard({
    super.key,
    required this.title,
    required this.monthlyValue,
    required this.dailyAverageValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: SizedBox(
        width: 116.0,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                Text(formatToMoneyAmount(monthlyValue.toString())),
                Text(
                  'Ø ${formatToMoneyAmount(dailyAverageValue.toString())}',
                  style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
