import 'package:flutter/cupertino.dart';
import 'package:moneybook/features/budgets/presentation/widgets/cards/budget_card.dart';
import 'package:moneybook/features/budgets/presentation/widgets/charts/budget_overview_chart.dart';

import '../../domain/entities/budget.dart';

class BudgetListPage extends StatefulWidget {
  final DateTime selectedDate;

  const BudgetListPage({
    super.key,
    required this.selectedDate,
  });

  @override
  State<BudgetListPage> createState() => _BudgetListPageState();
}

class _BudgetListPageState extends State<BudgetListPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BudgetOverviewChart(),
        Expanded(
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return const BudgetCard(
                budget: Budget(
                  id: 0,
                  categorieId: 0,
                  amount: 0.0,
                  used: 0.0,
                  remaining: 0.0,
                  percentage: 0.0,
                  currency: '€',
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
