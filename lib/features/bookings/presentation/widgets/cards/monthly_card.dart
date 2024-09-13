import 'package:flutter/material.dart';

import '../../../../../core/utils/number_formatter.dart';

class MonthlyCard extends StatelessWidget {
  final String title;
  final double monthlyValue;
  final double dailyAverageValue;
  final Color textColor;

  const MonthlyCard({
    super.key,
    required this.title,
    required this.monthlyValue,
    required this.dailyAverageValue,
    required this.textColor,
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
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, bottom: 3.0),
                  child: Text(
                    formatToMoneyAmount(monthlyValue.toString()),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: textColor, fontSize: 16.0),
                  ),
                ),
                Text(
                  'Ø ${formatToMoneyAmount(dailyAverageValue.toString())} p.T.',
                  overflow: TextOverflow.ellipsis,
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
