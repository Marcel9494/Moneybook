import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:moneybook/core/utils/number_formatter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../../core/consts/common_consts.dart';
import '../../../../../core/consts/route_consts.dart';
import '../../../../../shared/domain/value_objects/serie_mode_type.dart';
import '../../../../../shared/presentation/widgets/deco/bottom_sheet_header.dart';
import '../../../domain/entities/budget.dart';
import '../page_arguments/edit_budget_page_arguments.dart';

class BudgetCard extends StatelessWidget {
  final Budget budget;
  final DateTime selectedDate;

  const BudgetCard({
    super.key,
    required this.budget,
    required this.selectedDate,
  });

  void _openBudgetBottomSheet(BuildContext context) {
    showCupertinoModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: Wrap(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BottomSheetHeader(title: 'Budget bearbeiten:', indent: 16.0),
                  ListTile(
                    leading: const Icon(Icons.looks_one_outlined, color: Colors.cyanAccent),
                    title: const Text('Nur dieses Budget'),
                    trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                    onTap: () => Navigator.popAndPushNamed(
                      context,
                      editBudgetRoute,
                      arguments: EditBudgetPageArguments(
                        budget,
                        SerieModeType.one,
                      ),
                    ),
                  ),
                  const Divider(indent: 16.0, endIndent: 16.0),
                  ListTile(
                    leading: const Icon(Icons.repeat_one_rounded, color: Colors.cyanAccent),
                    title: const Text('Alle zukünftigen Budgets'),
                    trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                    onTap: () => Navigator.popAndPushNamed(
                      context,
                      editBudgetRoute,
                      arguments: EditBudgetPageArguments(
                        budget,
                        SerieModeType.onlyFuture,
                      ),
                    ),
                  ),
                  const Divider(indent: 16.0, endIndent: 16.0),
                  ListTile(
                    leading: const Icon(Icons.all_inclusive_rounded, color: Colors.cyanAccent),
                    title: const Text('Alle Budgets'),
                    trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                    onTap: () => Navigator.popAndPushNamed(
                      context,
                      editBudgetRoute,
                      arguments: EditBudgetPageArguments(
                        budget,
                        SerieModeType.all,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _calculateBudgetPerDay() {
    int remainingDaysOfMonth = 0;
    if (selectedDate.month == DateTime.now().month && selectedDate.year == DateTime.now().year) {
      int lastDayOfMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
      remainingDaysOfMonth = lastDayOfMonth - selectedDate.day + 1;
    } else {
      remainingDaysOfMonth = selectedDate.day + 1;
    }
    return formatToMoneyAmount((budget.remaining / remainingDaysOfMonth).toString());
  }

  Color _getBudgetColor() {
    if (budget.percentage <= 75.0) {
      return Colors.green.withOpacity(0.9);
    } else if (budget.percentage > 75.0 && budget.percentage < 100.0) {
      return Colors.yellowAccent.withOpacity(0.7);
    }
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openBudgetBottomSheet(context),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${budget.categorie}: ${formatToMoneyAmount(budget.used.toString())} / ${formatToMoneyAmount(budget.amount.toString())}',
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        formatToMoneyAmount(budget.remaining.toString()),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width - 50.0,
                  animation: true,
                  lineHeight: 21.0,
                  animationDuration: budgetAnimationDurationInMs,
                  percent: budget.percentage / 100 >= 1.0 ? 1.0 : budget.percentage / 100,
                  center: Text(
                    '${budget.percentage.toStringAsFixed(1).replaceAll('.', ',')} %',
                    style: const TextStyle(color: Colors.black87),
                  ),
                  barRadius: const Radius.circular(8.0),
                  progressColor: _getBudgetColor(),
                  padding: EdgeInsets.zero,
                  curve: Curves.linearToEaseOut,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(budget.percentage < 100.0
                    ? 'Du kannst noch ${_calculateBudgetPerDay()} pro Tag ausgeben.'
                    : 'Du hast dein Budgetlimit erreicht.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
