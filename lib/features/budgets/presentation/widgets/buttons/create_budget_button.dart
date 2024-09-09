import 'package:flutter/material.dart';

import '../../../../../core/consts/route_consts.dart';

class CreateBudgetButton extends StatelessWidget {
  const CreateBudgetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => Navigator.pushNamed(context, createBudgetRoute),
      icon: const Icon(Icons.add_rounded),
      label: const Text('Budget erstellen'),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        side: BorderSide(width: 0.75, color: Colors.grey.shade700),
      ),
    );
  }
}
