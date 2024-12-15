import 'package:flutter/cupertino.dart';

class SettingTitle extends StatelessWidget {
  final String title;
  final double paddingTop;

  const SettingTitle({
    super.key,
    required this.title,
    this.paddingTop = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTop, left: 14.0, bottom: 4.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }
}
