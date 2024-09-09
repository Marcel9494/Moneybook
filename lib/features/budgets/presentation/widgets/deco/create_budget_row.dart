import 'package:flutter/cupertino.dart';

import '../buttons/create_budget_button.dart';

class CreateBudgetRow extends StatelessWidget {
  const CreateBudgetRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(right: 8.0, left: 26.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Budgets:',
            style: TextStyle(fontSize: 16.0),
          ),
          CreateBudgetButton(),
        ],
      ),
    );
  }
}
