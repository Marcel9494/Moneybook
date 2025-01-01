import 'package:flutter/material.dart';

import '../../../../../core/utils/number_formatter.dart';

class PendingMonthlyCard extends StatelessWidget {
  final String title;
  final double pendingMonthlyValue;
  final Color textColor;

  const PendingMonthlyCard({
    super.key,
    required this.title,
    required this.pendingMonthlyValue,
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
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    formatToMoneyAmount(pendingMonthlyValue.toString()),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: textColor, fontSize: 14.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
