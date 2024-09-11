import 'package:flutter/material.dart';

import '../../../../../core/consts/route_consts.dart';

class CreateAccountButton extends StatelessWidget {
  const CreateAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, createAccountRoute),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
      ),
      child: const Text('Konto erstellen', style: TextStyle(fontSize: 13.0)),
    );
  }
}
