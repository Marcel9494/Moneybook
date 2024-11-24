import 'package:flutter/material.dart';
import 'package:moneybook/core/utils/number_formatter.dart';

import '../../../../bookings/domain/value_objects/amount_type.dart';

// TODO AmountTypeStats übergeben?
class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final AmountType amountType;
  final double amount;
  final double percentage;
  final double size;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    required this.amountType,
    required this.amount,
    required this.percentage,
    this.size = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
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
                Row(
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: text == amountType.name ? Colors.cyanAccent : Colors.grey,
                      ),
                    ),
                    text != AmountType.overallExpense.name && text != AmountType.overallIncome.name
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 2.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 0.4,
                                ),
                              ),
                              child: Text(
                                ' ${percentage.toStringAsFixed(1).replaceAll('.', ',')} %',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: text == amountType.name ? Colors.white : Colors.grey,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
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
