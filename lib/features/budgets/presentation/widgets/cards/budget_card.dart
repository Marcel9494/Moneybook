import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:moneybook/core/utils/number_formatter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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
        child: ClipPath(
          clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: _getBudgetColor(), width: 3.5)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 14.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: CircularPercentIndicator(
                      radius: 32.0,
                      animation: true,
                      animationDuration: budgetAnimationDurationInMs,
                      curve: Curves.linearToEaseOut,
                      percent: budget.percentage / 100 >= 1.0 ? 1.0 : budget.percentage / 100,
                      center: Text(
                        '${budget.percentage.toStringAsFixed(1).replaceAll('.', ',')} %',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: _getBudgetColor(),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(right: BorderSide(color: Colors.grey.shade700, width: 0.7)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            budget.categorie,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${formatToMoneyAmount(budget.used.toString())} / ${formatToMoneyAmount(budget.amount.toString())}',
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            budget.percentage < 100.0 ? 'Noch ${_calculateBudgetPerDay()} p.T. verfügbar' : 'Du hast dein Budgetlimit erreicht',
                            style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 12.0, right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatToMoneyAmount(budget.remaining.toString(), withoutDecimalPlaces: 6),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: _getBudgetColor(),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
