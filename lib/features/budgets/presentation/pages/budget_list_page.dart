import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/budgets/presentation/widgets/cards/budget_card.dart';
import 'package:moneybook/features/budgets/presentation/widgets/charts/budget_overview_chart.dart';

import '../bloc/budget_bloc.dart';

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
  void _loadBudgets(BuildContext context) {
    BlocProvider.of<BudgetBloc>(context).add(
      LoadMonthlyBudgets(widget.selectedDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BudgetOverviewChart(),
        BlocBuilder<BudgetBloc, BudgetState>(
          builder: (context, state) {
            _loadBudgets(context);
            if (state is Loaded) {
              return Expanded(
                child: ListView.builder(
                  itemCount: state.budgets.length,
                  itemBuilder: (BuildContext context, int index) {
                    return BudgetCard(budget: state.budgets[index]);
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
