import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showErrorFlushbar(BuildContext context, String message) {
  Flushbar(
    message: message,
    icon: const Icon(
      Icons.error_outline_rounded,
      size: 28.0,
      color: Colors.redAccent,
    ),
    duration: const Duration(seconds: 4),
    leftBarIndicatorColor: Colors.redAccent,
    flushbarPosition: FlushbarPosition.TOP,
    shouldIconPulse: false,
  ).show(context);
}
