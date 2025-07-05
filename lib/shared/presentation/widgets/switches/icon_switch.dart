import 'package:flutter/material.dart';

class IconSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String text;

  const IconSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.text = '',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(
          thumbIcon: WidgetStateProperty<Icon>.fromMap(
            <WidgetStatesConstraint, Icon>{
              WidgetState.selected: Icon(Icons.check),
              WidgetState.any: Icon(Icons.close),
            },
          ),
          value: value,
          onChanged: onChanged,
          activeTrackColor: Colors.cyanAccent,
          activeColor: Colors.cyan,
        ),
        SizedBox(width: 8.0),
        Text(
          text,
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}
