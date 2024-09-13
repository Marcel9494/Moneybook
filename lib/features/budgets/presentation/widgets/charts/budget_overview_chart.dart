import 'package:flutter/material.dart';
import 'package:moneybook/core/utils/number_formatter.dart';
import 'package:moneybook/features/budgets/presentation/widgets/text/text_with_vertical_divider.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../../../core/consts/common_consts.dart';
import '../../../../bookings/domain/entities/booking.dart';
import '../../../../bookings/domain/value_objects/booking_type.dart';
import '../../../domain/entities/budget.dart';

class BudgetOverviewChart extends StatefulWidget {
  final List<Budget> budgets;
  final List<Booking> bookings;

  const BudgetOverviewChart({
    super.key,
    required this.budgets,
    required this.bookings,
  });

  @override
  State<BudgetOverviewChart> createState() => _BudgetOverviewChartState();
}

class _BudgetOverviewChartState extends State<BudgetOverviewChart> {
  double _overallBudgetPercentage = 0.0;
  double _overallBudgetAmount = 0.0;
  double _overallBudgetUsed = 0.0;
  double _monthlyExpense = 0.0;
  double _monthlyIncome = 0.0;

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

  String _calculateNotAssigned() {
    _monthlyExpense = 0.0;
    for (int i = 0; i < widget.bookings.length; i++) {
      if (widget.bookings[i].type == BookingType.expense) {
        _monthlyExpense += widget.bookings[i].amount;
      }
    }
    return formatToMoneyAmount((_monthlyExpense - _overallBudgetUsed).toString());
  }

  String _calculateIncome() {
    _monthlyIncome = 0.0;
    for (int i = 0; i < widget.bookings.length; i++) {
      if (widget.bookings[i].type == BookingType.income) {
        _monthlyIncome += widget.bookings[i].amount;
      }
    }
    return formatToMoneyAmount(_monthlyIncome.toString());
  }

  double _calculateAvailable() {
    return _monthlyIncome - _monthlyExpense;
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
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 12.0),
          child: Row(
            children: [
              CircularPercentIndicator(
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
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: _getBudgetColor(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWithVerticalDivider(
                      verticalDividerColor: _getBudgetColor(),
                      description: 'Gesamtbudget',
                      value: '${formatToMoneyAmount(_overallBudgetUsed.toString())} / ${formatToMoneyAmount(_overallBudgetAmount.toString())}',
                    ),
                    TextWithVerticalDivider(
                      verticalDividerColor: Colors.cyanAccent,
                      description: 'Nicht zugeordnet',
                      value: _calculateNotAssigned(),
                    ),
                    TextWithVerticalDivider(
                      verticalDividerColor: Colors.cyanAccent,
                      description: 'Einnahmen',
                      value: _calculateIncome(),
                    ),
                    TextWithVerticalDivider(
                      verticalDividerColor: _calculateAvailable() >= 0.0 ? Colors.green.withOpacity(0.9) : Colors.redAccent,
                      description: 'Verfügbar',
                      value: formatToMoneyAmount((_calculateAvailable()).toString()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
