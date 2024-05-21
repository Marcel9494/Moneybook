import 'package:flutter/material.dart';

class SquareIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;

  const SquareIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: icon,
    );
  }
}
