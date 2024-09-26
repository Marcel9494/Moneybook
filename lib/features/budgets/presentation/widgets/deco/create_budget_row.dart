import 'package:flutter/cupertino.dart';

import '../buttons/create_budget_button.dart';

class CreateBudgetRow extends StatelessWidget {
  const CreateBudgetRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(26.0, 4.0, 12.0, 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Budgets',
            style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
          ),
          CreateBudgetButton(),
        ],
      ),
    );
  }
}
