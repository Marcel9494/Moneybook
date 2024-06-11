import 'package:flutter/material.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class SaveButton extends StatelessWidget {
  final String text;
  final RoundedLoadingButtonController saveBtnController;
  final VoidCallback onPressed;

  const SaveButton({
    super.key,
    required this.text,
    required this.saveBtnController,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: RoundedLoadingButton(
        controller: saveBtnController,
        color: Colors.cyanAccent,
        successColor: Colors.green,
        height: 40.0,
        borderRadius: 12.0,
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.black87),
        ),
      ),
    );
  }
}
