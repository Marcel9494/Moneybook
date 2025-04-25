import 'package:flutter/material.dart';
import 'package:moneybook/core/utils/number_formatter.dart';

import '../../../../../core/utils/app_localizations.dart';
import '../../../../bookings/domain/value_objects/amount_type.dart';
import '../../../domain/entities/amount_type_stats.dart';

class Indicator extends StatelessWidget {
  final AmountTypeStats amountTypeStat;
  final String text;
  final Color color;

  const Indicator({
    super.key,
    required this.amountTypeStat,
    required this.text,
    required this.color,
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
                color: text == amountTypeStat.amountType.name ? Colors.cyanAccent : Colors.grey,
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
                      AppLocalizations.of(context).translate(amountTypeStat.amountType.name),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: text == amountTypeStat.amountType.name ? Colors.cyanAccent : Colors.grey,
                      ),
                    ),
                    amountTypeStat.amountType.name != AmountType.overallExpense.name &&
                            amountTypeStat.amountType.name != AmountType.overallIncome.name &&
                            amountTypeStat.amountType.name != AmountType.buy.name &&
                            amountTypeStat.amountType.name != AmountType.sale.name
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
                                ' ${amountTypeStat.percentage.toStringAsFixed(1).replaceAll('.', ',')} %',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: text == amountTypeStat.amountType.name ? Colors.white : Colors.grey,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
                Text(
                  formatToMoneyAmount(amountTypeStat.amount.toString()),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: text == amountTypeStat.amountType.name ? Colors.white : Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
