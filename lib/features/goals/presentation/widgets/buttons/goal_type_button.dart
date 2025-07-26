import 'package:flutter/material.dart';

import '../../../../../core/utils/app_localizations.dart';
import '../../../domain/value_objects/goal_type.dart';

class GoalTypeButton extends StatefulWidget {
  GoalType goalType;
  Function onSelectionChanged;

  GoalTypeButton({
    super.key,
    required this.goalType,
    required this.onSelectionChanged,
  });

  @override
  State<GoalTypeButton> createState() => _GoalTypeButtonState();
}

class _GoalTypeButtonState extends State<GoalTypeButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton(
        segments: <ButtonSegment<GoalType>>[
          ButtonSegment(
            value: GoalType.savingsGoal,
            icon: const Icon(Icons.savings),
            label: Text(
              AppLocalizations.of(context).translate(GoalType.savingsGoal.name),
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
          ButtonSegment(
            value: GoalType.spendingGoal,
            icon: const Icon(Icons.monetization_on_rounded),
            label: Text(
              AppLocalizations.of(context).translate(GoalType.spendingGoal.name),
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
        ],
        selected: {widget.goalType},
        onSelectionChanged: (newSelectedValue) => widget.onSelectionChanged(newSelectedValue),
        showSelectedIcon: false,
        style: SegmentedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12.0),
              bottom: Radius.circular(4.0),
            ),
          ),
        ),
      ),
    );
  }
}
