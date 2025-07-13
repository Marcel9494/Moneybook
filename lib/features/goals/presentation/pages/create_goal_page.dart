import 'package:flutter/material.dart';
import 'package:moneybook/shared/presentation/widgets/input_fields/amount_text_field.dart';
import 'package:moneybook/shared/presentation/widgets/input_fields/title_text_field.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/utils/app_localizations.dart';
import '../../../../shared/presentation/widgets/buttons/save_button.dart';
import '../../domain/value_objects/goal_type.dart';
import '../widgets/buttons/date_button.dart';
import '../widgets/buttons/goal_type_button.dart';

class CreateGoalPage extends StatefulWidget {
  const CreateGoalPage({super.key});

  @override
  State<CreateGoalPage> createState() => _CreateGoalPageState();
}

class _CreateGoalPageState extends State<CreateGoalPage> {
  final TextEditingController _goalNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final RoundedLoadingButtonController _createGoalBtnController = RoundedLoadingButtonController();
  GoalType _goalType = GoalType.savingsGoal;

  void _createGoal(BuildContext context) {
    // TODO
  }

  void _changeGoalType(Set<GoalType> newGoalType) {
    setState(() {
      _goalType = newGoalType.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ziel erstellen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GoalTypeButton(
                  goalType: _goalType,
                  onSelectionChanged: (goalType) => _changeGoalType(goalType),
                ),
                TitleTextField(
                  titleController: _goalNameController,
                  hintText: 'Name',
                ),
                AmountTextField(
                  amountController: _amountController,
                  hintText: 'Betrag',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DateButton(
                      text: 'Startdatum',
                      startDate: DateTime.now(),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 28.0,
                    ),
                    DateButton(
                      text: 'Zieldatum',
                      startDate: DateTime.now().add(Duration(days: 90)),
                    ),
                  ],
                ),
                Text('Zeitraum: 3 Monate'), // TODO hier weitermachen und dynamisch implementieren
                SaveButton(
                  text: AppLocalizations.of(context).translate('erstellen'),
                  saveBtnController: _createGoalBtnController,
                  onPressed: () => _createGoal(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
