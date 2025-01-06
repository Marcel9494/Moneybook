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
      backgroundColor: Color(0xFF1c1b20),
      builder: (BuildContext context) {
        return Material(
          color: Color(0xFF1c1b20),
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
    int numberOfDaysThisMonth = daysInMonth(selectedDate.year, selectedDate.month);
    if (selectedDate.month == DateTime.now().month && selectedDate.year == DateTime.now().year) {
      numberOfDaysThisMonth -= DateTime.now().day;
    }
    return formatToMoneyAmount((budget.remaining / numberOfDaysThisMonth).toString());
  }

  int daysInMonth(int year, int month) {
    DateTime firstDayNextMonth = (month < 12) ? DateTime(year, month + 1, 1) : DateTime(year + 1, 1, 1);
    DateTime lastDayCurrentMonth = firstDayNextMonth.subtract(Duration(days: 1));
    return lastDayCurrentMonth.day;
  }

  Color _getBudgetColor() {
    if (budget.remaining >= 0.0) {
      return Colors.green.withOpacity(0.9);
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
              padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
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
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(color: Colors.grey.shade700, width: 0.7)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
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
                              budget.remaining <= 0.0 ? 'Du hast dein Budgetlimit erreicht' : 'Noch ${_calculateBudgetPerDay()} p.T. verfügbar',
                              style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
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
