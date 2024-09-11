import 'package:flutter/material.dart';

import '../../../../../core/consts/route_consts.dart';

class CreateBudgetButton extends StatelessWidget {
  const CreateBudgetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => Navigator.pushNamed(context, createBudgetRoute),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        side: BorderSide(width: 0.75, color: Colors.cyanAccent.withOpacity(0.75)),
      ),
      child: const Text('Budget erstellen', style: TextStyle(fontSize: 13.0)),
    );
  }
}
