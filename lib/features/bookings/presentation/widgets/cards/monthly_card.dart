import 'package:flutter/material.dart';
import 'package:moneybook/shared/presentation/widgets/dialogs/info_icon_with_dialog.dart';

import '../../../../../core/utils/number_formatter.dart';

class MonthlyCard extends StatelessWidget {
  final String title;
  final double monthlyValue;
  final double dailyAverageValue;
  final Color textColor;
  final bool showInfo;

  const MonthlyCard({
    super.key,
    required this.title,
    required this.monthlyValue,
    required this.dailyAverageValue,
    required this.textColor,
    this.showInfo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: SizedBox(
        width: 116.0,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 8.0, 8.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12.0),
                    ),
                    showInfo
                        ? InfoIconWithDialog(
                            title: title,
                            text: 'Es werden nur Investment Buchungen zu Käufen und Verkäufen mit einberechnet.\n\nKäufe - Verkäufe = Differenz')
                        : const SizedBox(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    formatToMoneyAmount(monthlyValue.toString()),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: textColor, fontSize: 14.0),
                  ),
                ),
                Text(
                  'Ø ${formatToMoneyAmount(dailyAverageValue.toString())} p.T.',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11.0, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
