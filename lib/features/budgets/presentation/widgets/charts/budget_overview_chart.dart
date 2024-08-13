import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../../../core/consts/common_consts.dart';
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
  double _overallBudgetAmount = 0.0;
  double _overallBudgetUsed = 0.0;

  void _calculateOverallBudgetValues() {
    _overallBudgetUsed = 0.0;
    _overallBudgetAmount = 0.0;
    for (int i = 0; i < widget.budgets.length; i++) {
      _overallBudgetUsed += widget.budgets[i].used;
      _overallBudgetAmount += widget.budgets[i].amount;
    }
    if (_overallBudgetAmount == 0) {
      _overallBudgetPercentage = 0.0;
    } else {
      _overallBudgetPercentage = (_overallBudgetUsed / _overallBudgetAmount) * 100;
    }
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
    _calculateOverallBudgetValues();
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: CircularPercentIndicator(
        radius: 60.0,
        lineWidth: 10.0,
        animation: true,
        animationDuration: budgetAnimationDurationInMs,
        curve: Curves.linearToEaseOut,
        percent: _overallBudgetPercentage / 100 >= 1.0 ? 1.0 : _overallBudgetPercentage / 100,
        center: Text(
          '${_overallBudgetPercentage.toStringAsFixed(1).replaceAll('.', ',')} %',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        footer: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            'Gesamt: ${_overallBudgetUsed.toStringAsFixed(2).replaceAll('.', ',')} € / ${_overallBudgetAmount.toStringAsFixed(2).replaceAll('.', ',')} €',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
            ),
          ),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: _getBudgetColor(),
      ),
    );
  }
}
