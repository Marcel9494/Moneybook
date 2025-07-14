import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:moneybook/shared/presentation/widgets/input_fields/amount_text_field.dart';
import 'package:moneybook/shared/presentation/widgets/input_fields/title_text_field.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/consts/common_consts.dart';
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
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now().add(Duration(days: 90));

  void _createGoal(BuildContext context) {
    // TODO
  }

  void _changeGoalType(Set<GoalType> newGoalType) {
    setState(() {
      _goalType = newGoalType.first;
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: DateTime(2014),
      lastDate: DateTime(DateTime.now().year + 100),
    );
    if (pickedStartDate != null) {
      if (pickedStartDate.isAfter(_selectedEndDate)) {
        Flushbar(
          title: AppLocalizations.of(context).translate('startdatum_nach_zieldatum'),
          message: AppLocalizations.of(context).translate('startdatum_nach_zieldatum_beschreibung'),
          icon: const Icon(Icons.error_outline_rounded, color: Colors.redAccent),
          duration: const Duration(milliseconds: flushbarDurationInMs),
          leftBarIndicatorColor: Colors.redAccent,
          flushbarPosition: FlushbarPosition.TOP,
        ).show(context);
      } else if (pickedStartDate != _selectedStartDate) {
        setState(() {
          _selectedStartDate = pickedStartDate;
        });
      }
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedEndDate = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate,
      firstDate: DateTime(2014),
      lastDate: DateTime(DateTime.now().year + 100),
    );
    if (pickedEndDate != null) {
      if (pickedEndDate.isBefore(_selectedStartDate)) {
        Flushbar(
          title: AppLocalizations.of(context).translate('zieldatum_vor_startdatum'),
          message: AppLocalizations.of(context).translate('zieldatum_vor_startdatum_beschreibung'),
          icon: const Icon(Icons.error_outline_rounded, color: Colors.redAccent),
          duration: const Duration(milliseconds: flushbarDurationInMs),
          leftBarIndicatorColor: Colors.redAccent,
          flushbarPosition: FlushbarPosition.TOP,
        ).show(context);
      } else if (pickedEndDate != _selectedEndDate) {
        setState(() {
          _selectedEndDate = pickedEndDate;
        });
      }
    }
  }

  String _formatPeriodOfTime(DateTime start, DateTime end) {
    Duration diff = end.difference(start);
    int totalDays = diff.inDays;

    int years = totalDays ~/ 365;
    int remainingDays = totalDays % 365;

    int months = remainingDays ~/ 30;
    remainingDays %= 30;

    int weeks = remainingDays ~/ 7;
    int days = remainingDays % 7;

    List<String> parts = [];

    if (years > 0) parts.add('$years ${years == 1 ? "Jahr" : "Jahre"}');
    if (months > 0) parts.add('$months ${months == 1 ? "Monat" : "Monate"}');
    if (weeks > 0) parts.add('$weeks ${weeks == 1 ? "Woche" : "Wochen"}');
    if (days > 0) parts.add('$days ${days == 1 ? "Tag" : "Tage"}');

    String formattedPeriodOfTime = parts.join(', ');

    return '$formattedPeriodOfTime\n(${totalDays} Tage)';
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
                      selectedDate: _selectedStartDate,
                      onPressed: () => _selectStartDate(context),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 28.0,
                    ),
                    DateButton(
                      text: 'Zieldatum',
                      selectedDate: _selectedEndDate,
                      onPressed: () => _selectEndDate(context),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
                  child: Text(
                    'Zeitraum:\n${_formatPeriodOfTime(_selectedStartDate, _selectedEndDate)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
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
