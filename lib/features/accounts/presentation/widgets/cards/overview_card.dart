import 'package:flutter/material.dart';

import '../../../../../core/utils/number_formatter.dart';
import '../../../../../shared/presentation/widgets/dialogs/info_icon_with_dialog.dart';

class OverviewCard extends StatelessWidget {
  final String title;
  final double value;
  final Color textColor;
  final String infoDialogText;

  const OverviewCard({
    super.key,
    required this.title,
    required this.value,
    required this.textColor,
    required this.infoDialogText,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12.0),
                    ),
                    InfoIconWithDialog(
                      title: title,
                      text: infoDialogText,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    formatToMoneyAmount(value.toString()),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: textColor),
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
