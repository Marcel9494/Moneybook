import 'package:flutter/material.dart';

class TextWithVerticalDivider extends StatelessWidget {
  final Color verticalDividerColor;
  final String description;
  final String value;

  const TextWithVerticalDivider({
    super.key,
    required this.verticalDividerColor,
    required this.description,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: IntrinsicHeight(
        child: Row(
          children: [
            VerticalDivider(
              color: verticalDividerColor,
              thickness: 2.0,
              indent: 4.0,
              endIndent: 4.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
