import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../domain/entities/budget.dart';

class BudgetOverviewChart extends StatefulWidget {
  final List<Budget> budgets;

  const BudgetOverviewChart({
    super.key,
    required this.budgets,
  });

  @override
  State<BudgetOverviewChart> createState() => _BudgetOverviewChartState();
}

class _BudgetOverviewChartState extends State<BudgetOverviewChart> {
  double _overallBudgetPercentage = 0.0;

  double _calculateOverallBudgetPercentage() {
    _overallBudgetPercentage = 0.0;
    if (widget.budgets.isEmpty) {
      return 0.0;
    }
    for (int i = 0; i < widget.budgets.length; i++) {
      _overallBudgetPercentage += widget.budgets[i].percentage;
    }
    return _overallBudgetPercentage / widget.budgets.length;
  }

  Color _getBudgetColor() {
    if (_overallBudgetPercentage <= 75.0) {
      return Colors.green.withOpacity(0.9);
    } else if (_overallBudgetPercentage > 75.0 && _overallBudgetPercentage < 100.0) {
      return Colors.yellowAccent.withOpacity(0.7);
    }
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    _overallBudgetPercentage = _calculateOverallBudgetPercentage();
    return CircularPercentIndicator(
      radius: 60.0,
      lineWidth: 13.0,
      animation: true,
      percent: _overallBudgetPercentage / 100 >= 1.0 ? 1.0 : _overallBudgetPercentage / 100,
      center: Text(
        '${_overallBudgetPercentage.toStringAsFixed(1).replaceAll('.', ',')} %',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
      footer: const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          // TODO hier weitermachen und Overall Budgetwerte berechnen
          "Gesamt: 100€ / 500€",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: _getBudgetColor(),
    );
  }
}
