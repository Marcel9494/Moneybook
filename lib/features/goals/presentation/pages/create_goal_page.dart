import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/core/consts/route_consts.dart';
import 'package:moneybook/shared/presentation/widgets/input_fields/amount_text_field.dart';
import 'package:moneybook/shared/presentation/widgets/input_fields/title_text_field.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/utils/app_localizations.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../shared/presentation/widgets/buttons/save_button.dart';
import '../../../bookings/domain/value_objects/amount.dart';
import '../../domain/entities/goal.dart';
import '../../domain/value_objects/goal_type.dart';
import '../bloc/goal_bloc.dart';
import '../widgets/buttons/date_button.dart';
import '../widgets/buttons/goal_type_button.dart';

class CreateGoalPage extends StatefulWidget {
  const CreateGoalPage({super.key});

  @override
  State<CreateGoalPage> createState() => _CreateGoalPageState();
}

class _CreateGoalPageState extends State<CreateGoalPage> {
  final GlobalKey<FormState> _goalFormKey = GlobalKey<FormState>();
  final TextEditingController _goalNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final RoundedLoadingButtonController _createGoalBtnController = RoundedLoadingButtonController();
  GoalType _goalType = GoalType.savingsGoal;
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now().add(Duration(days: 90));

  void _createGoal(BuildContext context) {
    final FormState form = _goalFormKey.currentState!;
    if (form.validate() == false) {
      _createGoalBtnController.error();
      Timer(const Duration(milliseconds: durationInMs), () {
        _createGoalBtnController.reset();
      });
    } else {
      _createGoalBtnController.success();
      Goal newGoal = Goal(
        id: 0, // Id wird von der Datenbank gesetzt
        name: _goalNameController.text,
        amount: 0.0,
        goalAmount: Amount.getValue(_amountController.text),
        currency: Amount.getCurrency(_amountController.text),
        startDate: _selectedStartDate,
        endDate: _selectedEndDate,
        type: _goalType,
      );
      BlocProvider.of<GoalBloc>(context).add(CreateGoal(newGoal));
      Timer(const Duration(milliseconds: durationInMs), () {
        Navigator.pop(context);
        Navigator.popAndPushNamed(context, goalOverviewRoute);
      });
    }
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
            child: Form(
              key: _goalFormKey,
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
                      'Zeitraum:\n${DateHelper.formatPeriodOfTime(_selectedStartDate, _selectedEndDate)}',
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
      ),
    );
  }
}
