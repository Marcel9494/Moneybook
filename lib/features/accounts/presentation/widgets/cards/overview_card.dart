import 'package:flutter/material.dart';

import '../../../../../core/utils/number_formatter.dart';

class OverviewCard extends StatelessWidget {
  final String title;
  final double value;
  final Color textColor;

  const OverviewCard({
    super.key,
    required this.title,
    required this.value,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, overflow: TextOverflow.ellipsis),
                Text(
                  formatToMoneyAmount(value.toString()),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
