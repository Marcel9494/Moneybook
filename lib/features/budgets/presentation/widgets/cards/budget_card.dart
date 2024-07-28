import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:moneybook/core/utils/number_formatter.dart';

import '../../../../../core/consts/route_consts.dart';
import '../../../../../shared/domain/value_objects/edit_mode_type.dart';
import '../../../../../shared/presentation/widgets/deco/bottom_sheet_header.dart';
import '../../../data/models/budget_model.dart';
import '../page_arguments/edit_budget_page_arguments.dart';

class BudgetCard extends StatelessWidget {
  final BudgetModel budget;

  const BudgetCard({
    super.key,
    required this.budget,
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
                        EditModeType.one,
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
                        EditModeType.onlyFuture,
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
                        EditModeType.all,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openBudgetBottomSheet(context),
      child: Card(
        child: Text('${budget.categorie.name} ${formatToMoneyAmount(budget.amount.toString())}'),
      ),
    );
  }
}
