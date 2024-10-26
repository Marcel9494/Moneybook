import 'package:flutter/material.dart';
import 'package:moneybook/core/utils/number_formatter.dart';

import '../../../../bookings/domain/value_objects/amount_type.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final AmountType amountType;
  final double amount;
  final double size;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    required this.amountType,
    required this.amount,
    this.size = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: VerticalDivider(
                color: text == amountType.name ? Colors.cyanAccent : Colors.grey,
                thickness: 2.0,
                indent: 4.0,
                endIndent: 4.0,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: text == amountType.name ? Colors.cyanAccent : Colors.grey,
                  ),
                ),
                Text(
                  formatToMoneyAmount(amount.toString()),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: text == amountType.name ? Colors.white : Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
