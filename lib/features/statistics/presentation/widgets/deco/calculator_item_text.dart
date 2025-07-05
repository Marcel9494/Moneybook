import 'package:flutter/cupertino.dart';

import '../../../../../shared/presentation/widgets/dialogs/info_icon_with_dialog.dart';

class CalculatorItemText extends StatelessWidget {
  final String title;
  final String description;
  final double fontSize;
  final FontWeight fontWeight;
  final double topPadding;
  final double leftPadding;
  final bool showInfoIcon;

  const CalculatorItemText({
    super.key,
    required this.title,
    required this.description,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.bold,
    this.topPadding = 12.0,
    this.leftPadding = 12.0,
    this.showInfoIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, left: leftPadding, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
          ),
          showInfoIcon
              ? InfoIconWithDialog(
                  title: title,
                  text: description,
                  iconSize: 24.0,
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
